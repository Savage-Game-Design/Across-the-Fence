#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_composite_selector.sqf
    Author:
    Date: 2024-02-02
    Last Update: 2024-02-02
    Public: Yes

    Description:
        Standard selector node. Runs children in order until one succeeds.

        If a child is currently running, and a previous child decorator becomes runnable,
        the currently running child can be interrupted and execution can jump to the previous
        decorator.

        I.e, earlier children can take priority over currently executing later children.

        See "abortLowerPriority" on decorator nodes.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children [ARRAY]

    Returns:
        Behaviour tree selector node [HASHMAP]

    Example(s):
        [] call vgm_g_fnc_btree_composite_selector;
 */

params ["_params", "_children"];

createHashMapFromArray [
    ["type", NODE_TYPE_SELECTOR],
    ["name", _params getOrDefault ["name", "selector"] ],
    ["children", _children]
]

