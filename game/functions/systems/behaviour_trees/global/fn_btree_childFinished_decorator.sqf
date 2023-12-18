/*
    File: fn_btree_childFinished_decorator.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2023-12-17
    Public: No

    Description:
        Called when one of the node's children has finished executing.

        This is called for stack frames with the 'decorator' node type.

    Parameter(s):
        _stackItem - The stack frame of the node whose child has finished [HASHMAP]
        _childResult - The result the child exited with [STRING]

    Returns:
        The next action to perform:
            [_nextActionParams, _nextAction] [ARRAY, CODE]

    Example(s):
        N/A
 */

#include "..\behaviour_trees.inc"

params ["_stackItem", "_childResult"];

private _node = _stackItem get "node";
private _state = _stackItem get "state";

private _result = [_node, _state, _childResult] call (_node get "onChildFinished");
_result params ["_statusCode"];

if (_statusCode isEqualTo RESULT_RUNNING) exitWith {
    [[0], ACTION_RUN_CHILD]
};

[[_childResult], ACTION_RETURN_TO_PARENT]
