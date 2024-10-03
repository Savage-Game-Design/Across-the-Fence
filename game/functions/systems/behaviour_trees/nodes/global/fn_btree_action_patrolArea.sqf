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

    private _nodeParams = [_node, _state] call vgm_g_fnc_btree_getNodeParams;
    // Potential bug here if the blackboard data carries over from earlier. Should it be wiped when the node exits?
    private _patrolCenter = _nodeParams getOrDefaultCall ["center", { getPosATL leader _group }, true];
    private _patrolRadius = _nodeParams getOrDefaultCall ["radius", { 50 + random 100 }, true];
    private _patrolAngleChange = _nodeParams getOrDefaultCall ["angleChange", { 30 * (selectRandom [1, -1]) }, true];

    //Too far away, we should move quickly to reach the patrol area.
    private _desiredSpeedMode =
        ["LIMITED", "FULL"] select (leader _extern_group distance2D _patrolCenter > _patrolRadius * 1.25);

    private _nextDistance = _patrolRadius * (0.8 + random 0.2);
    private _nextAngle = (_patrolCenter getDir getPos leader _group) + _patrolAngleChange;
    private _nextPosition = _patrolCenter getPos [_nextDistance, _nextAngle];

    [_nextPosition, _desiredSpeedMode]
}];

_action set ["name", "patrol area"];

_action set ["onEnter", {
    params ["_node", "_state"];

    _extern_group setCombatMode "RED";
    _extern_group setBehaviour "SAFE";
    _extern_group setFormation "COLUMN";
    [_group, "AUTO"] call vgm_g_fnc_btree_setGroupStance;

    private _nextPoint = [_node, _state] call (_node get "getNextPoint");
    [_extern_group, _nextPoint # 0, _nextPoint # 1, 15] call vgm_g_fnc_btree_moveTo_start;

    [ RESULT_RUNNING ]
}];

_action set ["onTick", {
    params ["_node", "_state"];

    private _isAtDestination = [_extern_group] call vgm_g_fnc_btree_moveTo_execute;

    if (_isAtDestination) then {
        private _nextPoint = [_node, _state] call (_node get "getNextPoint");
        [_extern_group, _nextPoint # 0, _nextPoint # 1, 15] call vgm_g_fnc_btree_moveTo_start;
        [_extern_group] call vgm_g_fnc_btree_moveTo_execute;
    };

    [ RESULT_RUNNING ]
}];

_action set ["onExit", {
    params ["_node", "_state", "_result"];
    // Cleanup only, no return value.
}];

_action
