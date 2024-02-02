#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_returnToParent.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2024-02-02
    Public: No

    Description:
        Behaviour tree action
        Exits the currently executing node and decides what to execute next based on its parent.

    Parameter(s):
        _childResult - Result from the node that completed [STRING]

    Variables defined in environment:
        _extern_stack - Current stack of the behaviour tree.

    Returns:
        The next action to perform:
            [_nextActionParams, _nextAction] [ARRAY, CODE]

    Example(s):
        [RESULT_SUCCEEDED] call vgm_g_fnc_btree_returnToParent
        // or
        [RESULT_SUCCEEDED] call ACTION_RETURN_TO_PARENT
 */

params ["_childResult"];

private _currentStackIndex = count _extern_stack - 1;
private _currentStackItem = (_extern_stack # _currentStackIndex);

private _node = _currentStackItem get "node";
private _state = _currentStackItem get "state";

[format ["Return to parent of node %1 (%2) with result %3", _node get "name", _node get "type", _childResult]] call vgm_g_fnc_btree_log;

private _nodeType = _node get "type";
private _handler = localNamespace getVariable "vgm_l_btree_exitNodeHandlers" get _nodeType;
[_currentStackItem, _childResult] call _handler;

// Pop the top item off of the stack.
_extern_stack deleteAt _currentStackIndex;

if (count _extern_stack == 0) exitWith {
    [format ["Return from root node, suspending execution until next tick"]] call vgm_g_fnc_btree_log;
    NO_ACTION_UNTIL_NEXT_TICK
};

private _parentStackItem = (_extern_stack # (_currentStackIndex - 1));
private _parentNode = _parentStackItem get "node";
private _parentState = _parentStackItem get "state";
private _parentNodeType = _parentNode get "type";

private _handler = localNamespace getVariable "vgm_l_btree_childFinishedHandlers" get _parentNodeType;

// Parent childFinished hander decides the next action.
[_parentStackItem, _childResult] call _handler
