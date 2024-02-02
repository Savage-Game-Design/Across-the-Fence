#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_childFinished_action.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2024-02-02
    Public: No

    Description:
        Called when one of the stack frame's node's children has finished executing.

        This is called for stack frames with the 'action' node type.

    Parameter(s):
        _stackFrame - The stack frame of the node whose child has finished [HASHMAP]
        _childResult - The result the child exited with [STRING]

    Returns:
        The next action to perform:
            [_nextActionParams, _nextAction] [ARRAY, CODE]

    Example(s):
        N/A
 */


// Do nothing - actions can't have children.
