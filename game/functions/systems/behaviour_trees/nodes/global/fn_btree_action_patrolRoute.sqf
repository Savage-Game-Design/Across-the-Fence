#include "..\..\behaviour_trees.inc"

/*
    File: fn_btree_action_patrolRoute.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        Action node.

        Makes the group patrol along a specific route.

        Node parameters:
            routePositions - Array of positions in the route, in order they should be visited [ARRAY]
            speedMode - How fast the AI should move [STRING]
            isCircuit - Should the AI start again at the start of the route, on completion? [BOOLEAN]
            repeat - Should the node loop infinitely? [BOOLEAN]

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be empty for actions) [ARRAY]

    Returns:
        Action node [HASHMAP]

    Example(s):
        [createHashMap, []] call vgm_g_fnc_btree_action_patrolRoute;
 */

params ["_params", "_children"];

private _action = _this call vgm_g_fnc_btree_action_basic;

// Custom function - not a normal part of the node.
// Find the nearest point on the route that doesn't make the route longer.
// Consider a 2 point route that gets started half-way.
// AI should always go straight to the end, never back to the start.
_action set ["calculateBestStartingIndex", {
    params ["_node", "_state"];

    private _route = _state get "routePositions";
    private _directionIncrement = [_node, _state] call (_node get "getDirectionIncrement");

    // Find nearest point on route
    private _nearestDistance = 9999999999;
    private _nearestIndex = 0;
    private _groupPos = getPosATL leader _extern_group;
    {
        private _distance = _x distanceSqr _groupPos;
        if (_distance < _nearestDistance) then {
            _nearestDistance = _distance;
            _nearestIndex = _forEachIndex;
        };
    } forEach _route;

    private _startingIndex = _nearestIndex;

    // Check if it makes more sense to go to the next route point instead.
    private _nextRouteIndex = _nearestIndex + _directionIncrement;
    if (0 <= _nextRouteIndex && _nextRouteIndex < count _route) then {
        private _nearestPos = _route select _nearestIndex;
        private _nextRoutePos = _route select _nextRouteIndex;
        // Choose the next route position instead, if we're closer to it than the nearest route waypoint is.
        if (_groupPos distanceSqr _nextRoutePos < _nearestPos distanceSqr _nextRoutePos) then {
            _startingIndex = _nextRouteIndex;
        };
    };

    _startingIndex
}];

// Custom function - not a normal part of the node.
_action set ["getDirectionIncrement", {
    params ["_node", "_state"];

    // Check the start and end positions against the route cache, to see if the group should be heading in a specific direction.
    // This persists between calls to this node, so patrols remember where they were heading!
    _extern_blackboard getOrDefault ["routeDirectionCache", createHashMap, true] getOrDefault [_state get "routeHash", 1]
}];

// Custom function - not a normal part of the node.
_action set ["setDirectionIncrement", {
    params ["_node", "_state", "_newIncrement"];

    _extern_blackboard getOrDefault ["routeDirectionCache", createHashMap, true] set [_state get "routeHash", _newIncrement]
}];


_action set ["name", "patrol route"];

_action set ["onEnter", {
    params ["_node", "_state"];

    private _nodeParams = [_node] call vgm_g_fnc_btree_getNodeParams;
    private _route = _nodeParams getOrDefault ["routePositions", []];
    private _speedMode = _nodeParams getOrDefault ["speedMode", "LIMITED"];
    private _isCircuit = _nodeParams getOrDefault ["isCircuit", false];
    private _repeat = _nodeParams getOrDefault ["repeat", true];

    // Never start if not enough points, which means we can be guaranteed route has at least 2 points in the rest of this action.
    if (count _route < 2) exitWith {
        [ RESULT_FAILED ]
    };

    // Cache these values from nodeParams, so we can use sensible defaults. _state is also cheaper to access regularly (no func overhead)
    _state set ["routePositions", _route];
    // Use first + last position for lookups (e.g direction cache) to avoid hashing whole route.
    // Also means two routes with the same start/end positions could have some sensible behaviour.
    _state set ["routeHash", [_route # 0, _route # -1]];
    private _startingIndex = [_node, _state] call (_node get "calculateBestStartingIndex");
    _state set ["currentRouteIndex", _startingIndex];
    _state set ["speedMode", _speedMode];
    _state set ["isCircuit", _isCircuit];
    _state set ["repeat", _repeat];

    _extern_group setCombatMode "RED";
    _extern_group setBehaviourStrong "SAFE";
    _extern_group setFormation "COLUMN";
    [_extern_group, "AUTO"] call vgm_g_fnc_btree_setGroupStance;


    private _startingPoint = _route select _startingIndex;
    [_extern_group, _startingPoint, _speedMode, 15] call vgm_g_fnc_btree_moveTo_start;

    [ RESULT_RUNNING ]
}];

_action set ["onTick", {
    params ["_node", "_state"];

    private _isAtDestination = [_extern_group] call vgm_g_fnc_btree_moveTo_execute;

    private _result = [ RESULT_RUNNING ];

    if (_isAtDestination) then {
        private _route = _state get "routePositions";
        private _currentIndex = _state get "currentRouteIndex";
        private _currentDirection = [_node, _state] call (_node get "getDirectionIncrement");
        private _nextIndex = _currentIndex + _currentDirection;
        private _isAtEndOfRoute = _nextIndex < 0 || _nextIndex >= count _route;
        if (_isAtEndOfRoute && !(_state get "repeat")) exitWith {
            _result = [ RESULT_SUCCEEDED ];
        };

        if (_isAtEndOfRoute) then {
            // If the loop is a connected circuit, rather than a back-and-forth patrol route.
            if (_state get "isCircuit") exitWith {
                _nextIndex = [0, count _route - 1] select (_currentDirection < 0);
            };

            _currentDirection = _currentDirection * -1;
            [_node, _state, _currentDirection] call (_node get "setDirectionIncrement");
            _nextIndex = _currentIndex + _currentDirection;
        };

        _state set ["currentRouteIndex", _nextIndex];
        private _nextPosition = _route select _nextIndex;

        [_extern_group, _nextPosition, _state get "speedMode", 15] call vgm_g_fnc_btree_moveTo_start;
        [_extern_group] call vgm_g_fnc_btree_moveTo_execute;
    };

    _result
}];

_action set ["onExit", {
    params ["_node", "_state", "_result"];
    // Cleanup only, no return value.
}];

_action
