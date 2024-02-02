#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_decorator_basic.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2024-02-02
    Public: Yes

    Description:
        Decorator node.
        Allows a single child node to be run conditionally,
        or for other effects to be triggered before the child node runs.

        "abortLowerPriority" can be used when a decorator is a child of a selector,
        making control flow jump to this decorator if it becomes runnable.

        In practice, this means "condition" is checked every tick when "abortLowerPriority" is set,
        so be wary of running performance intensive code in the condition.

        "onChildFinished" can return RESULT_RUNNING to re-run the child, or otherwise modify the child's result.

        "onEnter" should return "RUNNING" to start execution of the child, any other result prevents the child being run.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be exactly 1 node) [ARRAY]

    Returns:
        Basic decorator behaviour tree node [HASHMAP]

    Example(s):
        [] call vgm_g_fnc_btree_decorator_basic;
 */

params ["_params", "_children"];

createHashMapFromArray [
    ["type", NODE_TYPE_DECORATOR],
    ["name", _params getOrDefault ["name", "basic decorator"]],
    ["abortLowerPriority", _params get ["abortLowerPriority", false]],
    ["condition", {
        params ["_node"];
        // Always run
        true
    }],
    ["onEnter", {
        params ["_node"];
        // Execute the child
        [RESULT_RUNNING]
    }],
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
]
