/*
    File: fn_btree_runCurrentNode_action.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2023-12-18
    Public: No

    Description:
        Runs the current node (i.e the node on the topmost stack frame).

        Only triggered when that node is of type "action".

    Parameter(s):
        _stackItem - Stack frame for the current node [HASHMAP]

    Returns:
        The next action to perform:
            [_nextActionParams, _nextAction] [ARRAY, CODE]

    Example(s):
        N/A
 */

#include "../behaviour_trees.inc"

params ["_stackItem"];

private _node = _stackItem get "node";
private _state = _stackItem get "state";

private _result = [_node, _state] call (_node get "onTick");
private _statusCode = _result # 0;

if (_statusCode isEqualTo RESULT_RUNNING) exitWith {
    NO_NEXT_ACTION
};

[[_statusCode], ACTION_RETURN_TO_PARENT]
