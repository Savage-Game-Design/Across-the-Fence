#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_composite_sequence.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-02-02
    Public: Yes

    Description:
        Standard sequence node. Runs children in order until one fails.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children [ARRAY]

    Returns:
        Selector behaviour tree node [HASHMAP]

    Example(s):
        [] call vgm_g_fnc_btree_composite_sequence;
 */

params ["_params", "_children"];

createHashMapFromArray [
    ["type", NODE_TYPE_SEQUENCE],
    ["name", _params getOrDefault ["name", "sequence"]],
    ["children", _children]
]
