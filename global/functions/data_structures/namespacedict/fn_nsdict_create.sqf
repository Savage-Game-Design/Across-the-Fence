/*
    File: fn_nsdict_create.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:

    
    Parameter(s):
        _localVariable - Description [DATATYPE, defaults to DEFAULTVALUE]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [parameter] call vn_fnc_myFunction
*/

if (isNil "nsdict_masterNamespace") then {
	nsdict_masterNamespace = false call para_g_fnc_create_namespace;
	nsdict_counter = 0;
	nsdict_separator = "->";
};

nsdict_counter = nsdict_counter + 1;

//Set the member list to 0;
nsdict_masterNamespace setVariable [str nsdict_counter, []];

str nsdict_counter