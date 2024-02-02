#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_action_basic.sqf
    Author:
    Date: 2024-02-02
    Last Update: 2024-02-02
    Public: No

    Description:
        Action node.
        Performs some action, possibly over multiple ticks of the tree.

        Cannot have any children.

        "onEnter" is called when the node is first visited.
        "onTick" is executed every tick, but will not run unless "onEnter" returns RESULT_RUNNING
        "onExit" is always called to clean up the node, including if the action is aborted.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be empty for actions) [ARRAY]

    Returns:
        Generic action node [HASHMAP]

    Example(s):
        [] call vgm_g_fnc_btree_action_basic;
 */

params ["_params", "_children"];

createHashMapFromArray [
    ["type", NODE_TYPE_ACTION],
    ["name", _params getOrDefault ["name", "generic action"]],
    ["onEnter", {
        params ["_node", "_state"];
        [ RESULT_RUNNING ]
    }],
    ["onTick", {
        params ["_node", "_sttate"];
        [ RESULT_SUCCEEDED ]
    }],
    ["onExit", {
        params ["_node", "_state", "_result"];
        // Cleanup only, no return value.
    }]
]
