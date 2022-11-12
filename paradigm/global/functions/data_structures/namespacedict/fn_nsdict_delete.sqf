/*
    File: fn_nsdict_delete.sqf
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
params ["_dict"];

private _members = [nsdict_masterNamespace getVariable _dict, []];

{
	[_dict, _x] call para_g_fnc_nsdict_remove;
} forEach _members;

nsdict_masterNamespace setVariable [_dict, nil];
