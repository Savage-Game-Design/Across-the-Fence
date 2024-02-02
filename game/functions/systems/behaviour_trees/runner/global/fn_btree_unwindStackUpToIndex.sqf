#include "..\..\behaviour_trees.inc"
/*
    File: fn_btree_unwindStackUpToIndex.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2024-02-02
    Public: No

    Description:
        Aborts nodes in the behaviour tree until we reach stack index X (exclusive).

    Parameter(s):
        _stackIndex - Index to unwind until [NUMBER]

    Variables defined in environment:
        _extern_stack - Current stack of the behaviour tree.

    Returns:
        Nothing

    Example(s):
        // Abort just the current node.
        private _currentStackIndex = count _extern_stack - 1;
        [_currentStackIndex - 1] call vgm_g_fnc_btree_unwindStackUpToIndex
 */

params ["_index"];

private _currentStackIndex = count _extern_stack - 1;

while {_currentStackIndex > _index} do {
    private _currentStackItem = (_extern_stack # _currentStackIndex);
    private _node = _currentStackItem get "node";
    private _state = _currentStackItem get "state";

    [format ["Aborting node %1 (%2) at stack position %3", _node get "name", _node get "type", _currentStackIndex]] call vgm_g_fnc_btree_log;

    private _nodeType = _node get "type";
    private _handler = localNamespace getVariable "vgm_l_btree_abortNodeHandlers" get _nodeType;
    [_currentStackItem] call _handler;

    _extern_stack deleteAt _currentStackIndex;

    _currentStackIndex = _currentStackIndex - 1;
};
