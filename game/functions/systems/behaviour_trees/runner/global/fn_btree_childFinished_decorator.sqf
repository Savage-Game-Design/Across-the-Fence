#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_childFinished_decorator.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2024-02-02
    Public: No

    Description:
        Called when one of the node's children has finished executing.

        This is called for stack frames with the 'decorator' node type.

    Parameter(s):
        _stackFrame - The stack frame of the node whose child has finished [HASHMAP]
        _childResult - The result the child exited with [STRING]

    Returns:
        The next action to perform:
            [_nextActionParams, _nextAction] [ARRAY, CODE]

    Example(s):
        N/A
 */


params ["_stackFrame", "_childResult"];

private _node = _stackFrame get "node";
private _state = _stackFrame get "state";

private _result = [_node, _state, _childResult] call (_node get "onChildFinished");
_result params ["_statusCode"];

if (_statusCode isEqualTo RESULT_RUNNING) exitWith {
    [format ["Re-running child of decorator (%1) next tick", _node get "name"]] call vgm_g_fnc_btree_log;
    NO_ACTION_UNTIL_NEXT_TICK
};

[[_statusCode], ACTION_RETURN_TO_PARENT]
