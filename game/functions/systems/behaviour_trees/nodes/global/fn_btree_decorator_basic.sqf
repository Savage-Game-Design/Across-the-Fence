#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_decorator_basic.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-10-03
    Public: Yes

    Description:
        Decorator node.
        Allows a single child node to be run conditionally,
        or for other effects to be triggered before the child node runs.

        "condition"
            - Called to check if the node can be entered.

        "onEnter"
            - Fires when the condition succeeds and the node is entered.
            - Should return "RUNNING" to start execution of the child, any other result prevents the child being run.

        "onChildFinished"
            - Called when the child node returns.
            - Can return RESULT_RUNNING to re-run the child, or otherwise modify the child's result.

        "onExit"
            - Called to clean up the node
            - Return value is ignored

        "abortLowerPriority"
            - Can be used when a decorator is a child of a selector,
              making control flow jump to this decorator if it becomes runnable.

        "abortChildrenOnConditionFailure"
            - If true, immediately stop all child nodes if the condition starts failing.

        "isService"
            - If true, run the "onTick" code every tick, while this decorator is running
              (i.e, any children are running)

        "onTreeAssigned"
            - Called when the tree is assigned to a group
            - Useful for setting up event handlers.

        "onTreeUnassigned"
            - Called when the tree is unassigned from the group or the group is deleted
            - Useful for cleaning up event handlers.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be exactly 1 node) [ARRAY]

    Returns:
        Basic decorator behaviour tree node [HASHMAP]

    Example(s):
        [] call vgm_g_fnc_btree_decorator_basic;
 */

params ["_params", "_children"];

private _node = [
    NODE_TYPE_DECORATOR,
    "basic decorator",
    _params
] call vgm_g_fnc_btree_nodeBase;

private _decoratorProperties = createHashMapFromArray [
    ["abortLowerPriority", _params getOrDefault ["abortLowerPriority", false]],
    ["abortChildrenOnConditionFailure", _params getOrDefault ["abortChildrenOnConditionFailure", false]],
    ["isService", false],
    ["condition", {
        params ["_node"];
        // Always run
        true
    }],
    ["onEnter", {
        params ["_node", "_state"];
        // Execute the child
        [RESULT_RUNNING]
    }],
    ["onTick", {}],
    ["onChildFinished", {
        params ["_node", "_state", "_childResult"];
        // Preserve child's result
        [ _childResult ]
    }],
    ["onExit", {
        params ["_node", "_state", "_result"];
        // Used for cleanup, no return value.
    }],
    // Ensure we only ever have one child
    ["children", [ _children # 0 ]]
];

_node merge [_decoratorProperties, true];

_node
