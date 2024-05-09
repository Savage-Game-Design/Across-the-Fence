/*
    File: fn_keyhandler_getAllKeybinds.sqf
    Author:  Savage Game Design
    Public: Yes

    Description:
        Retrieves all keybindings currently valid.

    Parameter(s):
        N/A

    Returns:
        Mapping of action names to key bindings (see para_c_fnc_keyhandler_init for data structure) [HASHMAP]

    Example(s):
        [] call para_c_fnc_keyhandler_getAllKeyBinds
*/

private _registeredActions = localNamespace getVariable "para_keyhandler_actions";
private _result = createHashMap;

{
    if (_x in _registeredActions) then {
        _result set [_x, _y];
    };
} forEach (profileNamespace getVariable "para_c_keyhandler_bindings");

_result
