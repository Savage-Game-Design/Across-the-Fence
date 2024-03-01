#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_enterNode_decorator.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2024-02-02
    Public: No

    Description:
        Handles entering a "decorator" type node.

    Parameter(s):
        _stackFrame - Stack frame for the current node [HASHMAP]

    Returns:
        The next action to perform:
            [_nextActionParams, _nextAction] [ARRAY, CODE]

    Example(s):
        N/A
 */


params ["_stackFrame"];

private _node = _stackFrame get "node";
private _state = _stackFrame get "state";

private _conditionResult = [_node] call (_node get "condition");
if (!_conditionResult) exitWith {
    [[RESULT_FAILED], ACTION_RETURN_TO_PARENT]
};

private _enterResult = [_node, _state] call (_node get "onEnter");
_enterResult params ["_statusCode"];

if (_statusCode isEqualTo RESULT_RUNNING) exitWith {
    _stackFrame set ["isInterruptNode", _node get "abortChildrenOnConditionFailure"];
    _stackFrame set ["isServiceNode", _node get "isService"];

    [[0], ACTION_RUN_CHILD]
};

[[_statusCode], ACTION_RETURN_TO_PARENT]
