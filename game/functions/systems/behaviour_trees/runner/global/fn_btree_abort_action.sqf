#include "..\..\behaviour_trees.inc"

/*
    File: fn_btree_abort_action.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2024-03-08
    Public: No

    Description:
        Immediately aborts the given stack frame.

        This should make sure any cleanup functions are called.

        This handler is for stack frames for "action" nodes.

    Parameter(s):
        _stackFrame - Stack item to abort [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_extern_stack # (count _extern_stack - 1)] call vgm_g_fnc_btree_abort_action;
 */

params ["_stackFrame"];

private _node = _stackFrame get "node";
private _state = _stackFrame get "state";

[_node, _state, RESULT_ABORTED] call (_node get "onExit");
