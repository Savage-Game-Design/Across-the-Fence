#include "..\..\behaviour_trees.inc"

/*
    File: fn_btree_action_moveToInvestigationPoint.sqf
    Author: Savage Game Design
    Date: 2024-03-03
    Last Update: 2024-03-08
    Public: No

    Description:
        Moves the group towards a point flagged for investigation.

        Fails if there's no point to investigate.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be empty for actions) [ARRAY]

    Returns:
        Action node [HASHMAP]

    Example(s):
        [createHashMap, []] call vgm_g_fnc_btree_action_moveToInvestigationPoint;
 */

params ["_params", "_children"];

private _action = _this call vgm_g_fnc_btree_action_basic;

_action set ["name", "move to investigation point"];

_action set ["onEnter", {
    params ["_node", "_state"];

    private _point = _extern_blackboard get "investigationPoint";

    if (isNil "_point") exitWith {
        [ RESULT_FAILED ]
    };

	_extern_group setCombatMode "RED";
	_extern_group setBehaviour "AWARE";
	_extern_group setFormation "COLUMN";
    [_group, "AUTO"] call vgm_g_fnc_btree_setGroupStance;

    [_extern_group, _point, "NORMAL", 15] call vgm_g_fnc_btree_moveTo_start;

    [ RESULT_RUNNING ]
}];

_action set ["onTick", {
    params ["_node", "_state"];

    private _point = _extern_blackboard get "investigationPoint";

    if (isNil "_point") exitWith {
        [ RESULT_FAILED ]
    };

    // Update to the latest position then execute the move.
    [_extern_group, _point] call vgm_g_fnc_btree_moveTo_updateDestination;
    private _isAtDestination = [_extern_group] call vgm_g_fnc_btree_moveTo_execute;

    if (_isAtDestination) then {
        _extern_blackboard deleteAt "investigationPoint";
        [ RESULT_SUCCEEDED ]
    };

    [ RESULT_RUNNING ]
}];

_action set ["onExit", {
    params ["_node", "_state", "_result"];
    // Cleanup only, no return value.
}];

_action
