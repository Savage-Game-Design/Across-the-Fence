/*
    File: fn_btree_enterNode_action.sqf
    Author:
    Date: 2023-12-17
    Last Update: 2023-12-17
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
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
