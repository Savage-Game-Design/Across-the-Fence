/*
    File: fn_btree_exitNode_decorator.sqf
    Author:
    Date: 2023-12-17
    Last Update: 2023-12-17
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_stackItem", "_result"];

private _node = _stackItem get "node";
private _state = _stackItem get "state";

[_node, _state, _result] call (_node get "onExit");
