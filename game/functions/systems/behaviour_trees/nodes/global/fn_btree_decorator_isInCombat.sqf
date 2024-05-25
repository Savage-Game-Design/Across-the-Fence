/*
    File: fn_btree_decorator_isInCombat.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-02-09
    Public: Yes

    Description:
        Decorator node (see basic decorator for more info).

        Executes only if the group is currently in combat.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be exactly 1 node) [ARRAY]

    Returns:
        Decorator behaviour tree node [HASHMAP]

    Example(s):
        [] call vgm_g_fnc_btree_decorator_isInCombat;
 */

params ["_params", "_children"];

private _decorator = _this call vgm_g_fnc_btree_decorator_basic;

_decorator set ["name", "Is group in combat?"];
_decorator set ["condition", {
    params ["_node", "_state"];

    behaviour _extern_group == "COMBAT"
}];

_decorator
