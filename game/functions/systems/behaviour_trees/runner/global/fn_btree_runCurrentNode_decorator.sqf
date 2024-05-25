#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_runCurrentNode_decorator.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2024-02-02
    Public: No

    Description:
        Runs the current node (i.e the node on the topmost stack frame).

        Only triggered when that node is of type "decorator".

    Parameter(s):
        _stackFrame - Stack frame for the current node [HASHMAP]

    Returns:
        The next action to perform:
            [_nextActionParams, _nextAction] [ARRAY, CODE]

    Example(s):
        N/A
 */

params ["_stackFrame"];

// If decorator is current node, it's waiting to run the child again.
[[0], ACTION_RUN_CHILD]
