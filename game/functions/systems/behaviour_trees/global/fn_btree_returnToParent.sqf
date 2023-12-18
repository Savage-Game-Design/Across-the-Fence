/*
    File: fn_btree_returnToParent.sqf
    Author:
    Date: 2023-12-17
    Last Update: 2023-12-17
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Variables defined in environment:
        _stack - Current stack of the behaviour tree.

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

#include "..\behaviour_trees.inc"

params ["_childResult"];

private _currentStackIndex = count _stack - 1;
private _currentStackItem = (_stack # _currentStackIndex);

private _node = _currentStackItem get "node";
private _state = _currentStackItem get "state";

[format ["Return to parent of node %1 (%2) with result %3", _node get "name", _node get "type", _childResult]] call vgm_g_fnc_btree_log;

private _nodeType = _node get "type";
private _handler = localNamespace getVariable "vgm_l_btree_exitNodeHandlers" get _nodeType;
[_currentStackItem, _childResult] call _handler;

// Pop the top item off of the stack.
_stack deleteAt _currentStackIndex;

if (count _stack == 0) exitWith {
    [format ["Return from root node, suspending execution until next tick"]] call vgm_g_fnc_btree_log;
    NO_NEXT_ACTION
};

private _parentStackItem = (_stack # (_currentStackIndex - 1));
private _parentNode = _parentStackItem get "node";
private _parentState = _parentStackItem get "state";
private _parentNodeType = _parentNode get "type";

private _handler = localNamespace getVariable "vgm_l_btree_childFinishedHandlers" get _parentNodeType;

// Parent childFinished hander decides the next action.
[_parentStackItem, _childResult] call _handler
