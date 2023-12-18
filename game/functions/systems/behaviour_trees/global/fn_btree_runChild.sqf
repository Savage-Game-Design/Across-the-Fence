/*
    File: fn_btree_runChild.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2023-12-18
    Public: No

    Description:
        Behaviour tree action
        Starts executing the child of the current node at index X.

    Parameter(s):
        _childIndex - Index of the child to start running [NUMBER]

    Variables defined in environment:
        _stack - Current stack of the behaviour tree.

    Returns:
        The next action to perform:
            [_nextActionParams, _nextAction] [ARRAY, CODE]

    Example(s):
        [0] call vgm_g_fnc_btree_runChild;
        // or
        [0] call ACTION_RUN_CHILD
 */
#include "..\behaviour_trees.inc"

params ["_childIndex"];

// Possible bug if stack is empty here
private _stackItem = (_stack # (count _stack - 1));
private _node = _stackItem get "node";

[format ["Running child: %1 (%2) at index %3", _node getOrDefault ["name", ""], _node get "type", _childIndex]] call vgm_g_fnc_btree_log;

if !(_node get "type" in [NODE_TYPE_DECORATOR, NODE_TYPE_SELECTOR, NODE_TYPE_SEQUENCE]) exitWith {
    [[format ["Cannot run child on node type %1 (name: %2)", _node get "type", _node get "name"]], ACTION_PANIC]
};

private _child = _node get "children" select _childIndex;
_stackItem get "state" set ["executingChildIndex", _childIndex];

[_child] call ACTION_ENTER_NODE
