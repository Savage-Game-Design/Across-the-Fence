/*
    File: fn_btree_enterNode_decorator.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2023-12-18
    Public: No

    Description:
        Handles entering a "decorator" type node.

    Parameter(s):
        _stackItem - Stack frame for the current node [HASHMAP]

    Returns:
        The next action to perform:
            [_nextActionParams, _nextAction] [ARRAY, CODE]

    Example(s):
        N/A
 */

#include "..\behaviour_trees.inc"

params ["_stackItem"];

private _node = _stackItem get "node";

private _conditionResult = [_node] call (_node get "condition");
if (!_conditionResult) exitWith {
    [[RESULT_FAILED], ACTION_RETURN_TO_PARENT]
};

private _enterResult = [_node] call (_node get "onEnter");
_enterResult params ["_statusCode"];

if (_statusCode isEqualTo RESULT_RUNNING) exitWith {
    _stackitem set ["isInterruptNode", _node get "abortChildrenOnConditionFailure"];
    _stackitem set ["isServiceNode", _node get "isService"];
    // TODO: Services stack

    [[0], ACTION_RUN_CHILD]
};

[[_statusCode], ACTION_RETURN_TO_PARENT]
