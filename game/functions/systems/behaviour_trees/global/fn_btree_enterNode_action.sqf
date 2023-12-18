/*
    File: fn_btree_enterNode_action.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2023-12-18
    Public: No

    Description:
        Handles entering an "action" type node.

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
private _state = _stackItem get "state";

private _enterResult = [_node, _state] call (_node get "onEnter");
_enterResult params ["_statusCode"];

if (_statusCode isEqualTo RESULT_RUNNING) exitWith {
    [[], ACTION_RUN_CURRENT_NODE]
};

[[_statusCode], ACTION_RETURN_TO_PARENT]
