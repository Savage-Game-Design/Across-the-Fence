/*
    File: fn_ai_public_var_get.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Gets a public variable in the given namespace.
        Adds the behaviour specific prefix to the variable.
        Behaviour specific prefix is used by rehandler
    
    Parameter(s):
        _namespace - Namespace to get variable from [NAMESPACE]
        _varName - Name of variable to get [STRING]
        _defaultValue - Default value [ANY]
    
    Returns:
        Value from namespace if set, else default value.
    
    Example(s):
        [_group, "currentThoughts", "defaultValue"] call para_g_fnc_ai_public_var_get;
*/

params ["_namespace", "_varName", "_defaultValue"];

_namespace getVariable [format ["para_public_ai_%1", _varName], _defaultValue]