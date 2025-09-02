#include "..\..\behaviour_trees.inc"

/*
    File: fn_btree_action_moveTo.sqf
    Author: Savage Game Design
    Date: 2024-03-03
    Last Update: 2025-05-14
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
        [createHashMap, []] call vgm_g_fnc_btree_action_moveTo;
 */

params ["_params", "_children"];

private _action = _this call vgm_g_fnc_btree_action_basic;

_action set ["name", "move to"];

_action set ["onEnter", {
    params ["_node", "_state"];

    private _nodeParams = [_node] call vgm_g_fnc_btree_getNodeParams;
    private _point = _nodeParams get "dest";
    private _combatMode = _nodeParams getOrDefault ["combatMode", "YELLOW"];
    private _behaviour = _nodeParams getOrDefault ["behaviour", "AWARE"];
    private _formation = _nodeParams getOrDefault ["formation", "COLUMN"];
    private _stance = _nodeParams getOrDefault ["stance", "AUTO"];
    private _speedMode = _nodeParams getOrDefault ["speedMode", "NORMAL"];

    if (isNil "_point") exitWith {
        [ RESULT_FAILED ]
    };

    _extern_group setCombatMode _combatMode;
    _extern_group setBehaviour _behaviour;
    _extern_group setFormation _formation;
    [_group, _stance] call vgm_g_fnc_btree_setGroupStance;

    [_extern_group, _point, _speedMode, 15] call vgm_g_fnc_btree_moveTo_start;

    [ RESULT_RUNNING ]
}];

_action set ["onTick", {
    params ["_node", "_state"];

    private _nodeParams = [_node] call vgm_g_fnc_btree_getNodeParams;
    private _point = _nodeParams get "dest";

    if (isNil "_point") exitWith {
        [ RESULT_FAILED ]
    };

    // Update to the latest position then execute the move.
    [_extern_group, _point] call vgm_g_fnc_btree_moveTo_updateDestination;
    private _isAtDestination = [_extern_group] call vgm_g_fnc_btree_moveTo_execute;

    if (_isAtDestination) exitWith {
        [ RESULT_SUCCEEDED ]
    };

    [ RESULT_RUNNING ]
}];

_action set ["onExit", {
    params ["_node", "_state", "_result"];
    // Cleanup only, no return value.
}];

_action
