#include "..\..\behaviour_trees.inc"

/*
    File: fn_btree_action_clearOrders.sqf
    Author: Savage Game Design
    Date: 2024-03-03
    Last Update: 2025-05-15
    Public: No

    Description:
        Clears the group's current orders.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be empty for actions) [ARRAY]

    Returns:
        Action node [HASHMAP]

    Example(s):
        [createHashMap, []] call vgm_g_fnc_btree_action_clearOrders;
 */

params ["_params", "_children"];

private _action = _this call vgm_g_fnc_btree_action_basic;

_action set ["name", "clear orders"];

_action set ["onEnter", {
    params ["_node", "_state"];

    _extern_group setVariable ["vgm_g_order", nil, true];

    [ RESULT_SUCCEEDED ]
}];

_action
