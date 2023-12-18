/*
    File: fn_btree_exitNode_action.sqf
    Author: Savage Game Design
    Date: 2023-12-17
    Last Update: 2023-12-18
    Public: No

    Description:
        Handles exiting from a "action" type node.

    Parameter(s):
        _stackItem - Stack frame of the current node (topmost stack frame) [HASHMAP]
        _result - Resulting status of the node - i.e, the status its exitin with [STRING]

    Returns:
        Nothing

    Example(s):
        N/A
 */

params ["_stackItem", "_result"];

private _node = _stackItem get "node";
private _state = _stackItem get "state";

[_node, _state, _result] call (_node get "onExit");
