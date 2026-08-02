#include "..\..\behaviour_trees.inc"

/*
    File: fn_btree_action_patrolArea.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        Action node.

        Makes the group patrol around a point.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be empty for actions) [ARRAY]

    Returns:
        Action node [HASHMAP]

    Example(s):
        [createHashMap, []] call vgm_g_fnc_btree_action_patrolArea;
 */

params ["_params", "_children"];

private _action = _this call vgm_g_fnc_btree_action_basic;

// Custom function - not a normal part of the node.
_action set ["getNextPoint", {
    params ["_node", "_state"];

    private _patrolCenter = _state get "center";
    private _patrolRadius = _state get "radius";
    private _patrolAngleChange = _state get "angleChange";

    //Too far away, we should move quickly to reach the patrol area.
    private _desiredSpeedMode =
        [_state get "speedMode", "FULL"] select (leader _extern_group distance2D _patrolCenter > _patrolRadius * 1.25);

    // Wider radius variation: 50-100% of patrol radius
    private _nextDistance = _patrolRadius * (0.5 + random 0.5);
    // Vary angle each step: 50-150% of base angle, 15% chance to reverse direction
    private _stepAngle = _patrolAngleChange * (0.5 + random 1.0);
    if (random 1 < 0.15) then { _stepAngle = _stepAngle * -1 };
    private _nextAngle = (_patrolCenter getDir getPos leader _extern_group) + _stepAngle;
    private _nextPosition = _patrolCenter getPos [_nextDistance, _nextAngle];

    [_nextPosition, _desiredSpeedMode]
}];

_action set ["name", "patrol area"];

_action set ["onEnter", {
    params ["_node", "_state"];

    private _nodeParams = [_node] call vgm_g_fnc_btree_getNodeParams;
    // Cache these values from nodeParams, so we can use sensible defaults. _state is also cheaper to access regularly.
    _state set ["center", _nodeParams getOrDefaultCall ["center", { getPosATL leader _group }]];
    _state set ["radius", _nodeParams getOrDefaultCall ["radius", { 50 + random 100 }]];
    _state set ["angleChange", _nodeParams getOrDefaultCall ["angleChange", { 30 * (selectRandom [1, -1]) }, true]];
    _state set ["speedMode", _nodeParams getOrDefault ["speedMode", "LIMITED"]];
    private _behaviour = _nodeParams getOrDefault ["behaviour", "SAFE"];
    _state set ["behaviour", _behaviour];

    _extern_group setCombatMode "RED";
    _extern_group setBehaviourStrong _behaviour;
    _extern_group setFormation (selectRandom ["COLUMN", "STAG COLUMN", "FILE", "LINE", "WEDGE"]);
    [_extern_group, "AUTO"] call vgm_g_fnc_btree_setGroupStance;

    private _nextPoint = [_node, _state] call (_node get "getNextPoint");
    [_extern_group, _nextPoint # 0, _nextPoint # 1, 15] call vgm_g_fnc_btree_moveTo_start;

    [ RESULT_RUNNING ]
}];

_action set ["onTick", {
    params ["_node", "_state"];

    // Handle halt-and-observe: group is stopped, listening/looking
    if (_state getOrDefault ["halting", false]) exitWith {
        if (time > (_state get "haltEndTime")) then {
            _state set ["halting", false];
            // Restore original behaviour
            _extern_group setBehaviourStrong (_state getOrDefault ["behaviour", "SAFE"]);
            [_extern_group, "AUTO"] call vgm_g_fnc_btree_setGroupStance;
            // 40% chance to change formation after halt
            if (random 1 < 0.4) then {
                _extern_group setFormation (selectRandom ["COLUMN", "STAG COLUMN", "FILE", "LINE", "WEDGE"]);
            };
            // Pick next waypoint
            private _nextPoint = [_node, _state] call (_node get "getNextPoint");
            [_extern_group, _nextPoint # 0, _nextPoint # 1, 15] call vgm_g_fnc_btree_moveTo_start;
            [_extern_group] call vgm_g_fnc_btree_moveTo_execute;
        };
        [ RESULT_RUNNING ]
    };

    private _isAtDestination = [_extern_group] call vgm_g_fnc_btree_moveTo_execute;

    if (_isAtDestination) then {
        // 30% chance to halt and observe at each waypoint
        if (random 1 < 0.3) then {
            _state set ["halting", true];
            _state set ["haltEndTime", time + 15 + random 30];
            _extern_group setBehaviourStrong "SAFE";
            [_extern_group, selectRandom ["MIDDLE", "AUTO"]] call vgm_g_fnc_btree_setGroupStance;
        } else {
            private _nextPoint = [_node, _state] call (_node get "getNextPoint");
            [_extern_group, _nextPoint # 0, _nextPoint # 1, 15] call vgm_g_fnc_btree_moveTo_start;
            [_extern_group] call vgm_g_fnc_btree_moveTo_execute;
        };
    };

    [ RESULT_RUNNING ]
}];

_action set ["onExit", {
    params ["_node", "_state", "_result"];
    // Cleanup only, no return value.
}];

_action
