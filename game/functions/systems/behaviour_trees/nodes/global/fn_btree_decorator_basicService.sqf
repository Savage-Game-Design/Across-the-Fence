#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_decorator_basicService.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-02-02
    Public: Yes

    Description:
        Decorator node (see basic decorator for more info).

        Simple service node, runs the onTick code whenever its in the stack, and whenever its entered.

        Used as a base for other nodes, or debugging.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be exactly 1 node) [ARRAY]

    Returns:
        Decorator behaviour tree node [HASHMAP]

    Example(s):
        [] call vgm_g_fnc_btree_decorator_basicService;
 */

params ["_params", "_children"];

private _decorator = _this call vgm_g_fnc_btree_decorator_basic;

_decorator set ["name", "basic service"];
_decorator set ["isService", true];
_decorator set ["onEnter", {
    params ["_node", "_state"];

    _this call (_node get "onTick");

    [ RESULT_RUNNING ]
}];
_decorator set ["onTick", {
    ["Basic service node executed"] call vgm_g_fnc_btree_log;
}];

_decorator
