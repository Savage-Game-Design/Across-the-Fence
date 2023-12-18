/*
    File: fn_btree_enterNode.sqf
    Author:
    Date: 2023-12-17
    Last Update: 2023-12-17
    Public: No

    Description:
        Called to try and run a new node in the behaviour tree.

    Parameter(s):
        _node - Node that's being entered [HashMap]

    Variables defined in environment:
        _stack - Current stack of the behaviour tree.

    Returns:
        [_nextActionParameters, _nextActionToRun] [ARRAY, CODE]

    Example(s):
        TODO
 */

#include "..\behaviour_trees.inc"

params ["_node"];

[format ["Entering node: %1 (%2)", _node getOrDefault ["name", ""], _node get "type"]] call vgm_g_fnc_btree_log;

private _nodeState = createHashMap;

private _stackItem = (createHashMapFromArray [
    ["node", _node],
    ["state", _nodeState],
    ["higherPriorityNodes", []],
    ["isInterruptNode", false],
    ["isServiceNode", false]
]);

_stack pushBack _stackItem;

private _nodeType = _node get "type";

private _handler = localNamespace getVariable "vgm_l_btree_enterNodeHandlers" get _nodeType;

private _result = [_stackItem] call _handler;

// Handler for the specific node type decides the next action
_result
