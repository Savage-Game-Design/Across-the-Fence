/*
    File: fn_btree_enterNode.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2024-01-26
    Public: No

    Description:
        Called to try and run a new node in the behaviour tree.

        Generally shouldn't be used by handlers, as it can break the flow of the behaviour tree.
        ACTION_RUN_CHILD is the correct choice most of the time.

    Parameter(s):
        _node - Node that's being entered [HashMap]

    Variables defined in environment:
        _extern_stack - Current stack of the behaviour tree.

    Returns:
        [_nextActionParameters, _nextActionToRun] [ARRAY, CODE]

    Example(s):
        [_node] call vgm_g_fnc_btree_enterNode;
        // or
        [_node] call ACTION_ENTER_NODE;
 */

#include "..\behaviour_trees.inc"

params ["_node"];

[format ["Entering node: %1 (%2)", _node getOrDefault ["name", ""], _node get "type"]] call vgm_g_fnc_btree_log;

private _nodeState = createHashMap;

private _stackFrame = (createHashMapFromArray [
    ["node", _node],
    ["state", _nodeState],
    ["higherPriorityNodes", []],
    ["isInterruptNode", false],
    ["isServiceNode", false]
]);

_extern_stack pushBack _stackFrame;

private _nodeType = _node get "type";

private _handler = localNamespace getVariable "vgm_l_btree_enterNodeHandlers" get _nodeType;

private _result = [_stackFrame] call _handler;

// Handler for the specific node type decides the next action
_result
