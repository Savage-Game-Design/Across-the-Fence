#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_decorator_alwaysSucceed.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-02-02
    Public: Yes

    Description:
        Decorator node.

        Runs the child, but always returns success after the child completes.

        Note: Will still return RESULT_ABORTED if aborted.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be exactly 1 node) [ARRAY]

    Returns:
        Decorator behaviour tree node [HASHMAP]

    Example(s):
        [] call vgm_g_fnc_btree_decorator_alwaysSucceed;
 */

params ["_params", "_children"];

private _decorator = _this call vgm_g_fnc_btree_decorator_basic;

_decorator set ["name", "always succeed"];

_decorator set ["onChildFinished", {
    params ["_node", "_state", "_childResult"];
    [ RESULT_SUCCEEDED ]
}];

_decorator
