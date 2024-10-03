#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_action_basic.sqf
    Author:
    Date: 2024-02-02
    Last Update: 2024-10-03
    Public: No

    Description:
        Action node.
        Performs some action, possibly over multiple ticks of the tree.

        Cannot have any children.

        "onEnter" is called when the node is first visited.
        "onTick" is executed every tick, but will not run unless "onEnter" returns RESULT_RUNNING
        "onExit" is always called to clean up the node, including if the action is aborted.

        "onTreeAssigned" is called when the tree is assigned to a group, and is useful for setting up event handlers.
        "onTreeUnassigned" is called when the tree is unassigned from the group or the group is deleted, and is useful for cleaning up event handlers.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be empty for actions) [ARRAY]

    Returns:
        Generic action node [HASHMAP]

    Example(s):
        [createHashMap, []] call vgm_g_fnc_btree_action_basic;
 */

params ["_params", "_children"];

private _node = [
    NODE_TYPE_ACTION,
    "generic action",
    _params
] call vgm_g_fnc_btree_nodeBase;

private _actionProperties = createHashMapFromArray [
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
];

_node merge [_actionProperties, true];

_node
