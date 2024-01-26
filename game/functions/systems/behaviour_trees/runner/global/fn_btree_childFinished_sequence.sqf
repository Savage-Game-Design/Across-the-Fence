/*
    File: fn_btree_childFinished_sequence.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2023-12-18
    Public: No

    Description:
        Called when one of the node's children has finished executing.

        This is called for stack frames with the 'sequence' node type.

    Parameter(s):
        _stackFrame - The stack frame of the node whose child has finished [HASHMAP]
        _childResult - The result the child exited with [STRING]

    Returns:
        The next action to perform:
            [_nextActionParams, _nextAction] [ARRAY, CODE]

    Example(s):
        N/A
 */

#include "..\behaviour_trees.inc"

params ["_stackFrame", "_childResult"];

private _node = _stackFrame get "node";
private _children = _node get "children";
private _lastExecutedChild = _stackFrame get "state" get "executingChildIndex";

if (_childResult isEqualTo RESULT_SUCCEEDED && _lastExecutedChild < count _children) exitWith {
    [[_lastExecutedChild + 1], ACTION_RUN_CHILD]
};

[[_childResult], ACTION_RETURN_TO_PARENT]
