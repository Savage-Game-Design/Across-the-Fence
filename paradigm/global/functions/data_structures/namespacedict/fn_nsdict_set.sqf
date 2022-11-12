/*
    File: fn_nsdict_set.sqf
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

params ["_dict", "_key", "_value"];

if (_key isEqualType []) then {
	_key = _key joinString nsdict_separator;
};

nsdict_masterNamespace getVariable _dict pushBackUnique _key;

_key = _dict + nsdict_separator + _key;
nsdict_masterNamespace setVariable [_key, _value];