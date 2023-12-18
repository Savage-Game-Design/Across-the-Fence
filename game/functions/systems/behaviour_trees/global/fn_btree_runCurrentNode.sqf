/*
    File: fn_btree_runCurrentNode.sqf
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

private _currentStackIndex = count _stack - 1;
private _currentStackItem = (_stack # _currentStackIndex);

private _node = _currentStackItem get "node";
private _state = _currentStackItem get "state";

[format ["Running current node %1 (%2)", _node get "name", _node get "type"]] call vgm_g_fnc_btree_log;

private _nodeType = _node get "type";
private _handler = localNamespace getVariable "vgm_l_btree_runCurrentNodeHandlers" get _nodeType;


// Handler for the current node type decides the next action.
[_currentStackItem] call _handler
