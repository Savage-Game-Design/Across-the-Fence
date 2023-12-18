/*
    File: fn_btree_abort_decorator.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2023-12-17
    Public: No

    Description:
        Immediately aborts the given stack frame.

        This should make sure any cleanup functions are called.

        This handler is for stack frames for "decorator" nodes.

    Parameter(s):
        _stackItem - Stack item to abort [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_stack # (count _stack - 1)] call vgm_g_fnc_btree_abort_decorator;
 */

params ["_stackItem"];

private _node = _stackItem get "node";
private _state = _stackItem get "state";

[_node, _state, RESULT_ABORTED] call (_node get "onChildFinished");
[_node, _state, RESULT_ABORTED] call (_node get "onExit");
