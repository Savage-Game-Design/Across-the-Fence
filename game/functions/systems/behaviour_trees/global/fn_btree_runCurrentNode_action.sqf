/*
    File: fn_btree_runCurrentNode_action.sqf
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

params ["_stackItem"];

private _node = _stackItem get "node";
private _state = _stackItem get "state";

private _result = [_node, _state] call (_node get "onTick");
private _statusCode = _result # 0;

if (_statusCode isEqualTo RESULT_RUNNING) exitWith {
    NO_NEXT_ACTION
};

[[_statusCode], ACTION_RETURN_TO_PARENT]
