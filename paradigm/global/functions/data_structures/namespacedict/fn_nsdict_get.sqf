/*
    File: fn_nsdict_get.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        No description added yet.
    
    Parameter(s):
        _localVariable - Description [DATATYPE, defaults to DEFAULTVALUE]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/

params ["_dict", "_key", "_default"];

if (_key isEqualType []) then {
	_key = _key joinString nsdict_separator;
};

_key = _dict + nsdict_separator + _key;

if (isNil "_default") exitWith {
	nsdict_masterNamespace getVariable _key
};

nsdict_masterNamespace getVariable [_key, _default]