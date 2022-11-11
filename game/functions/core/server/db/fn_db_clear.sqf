/*
    File: fn_db_clear.sqf
    Author: Cerebral
    Date: 2022-11-11
    Last Update: 2022-11-11
    Public: No

    Description:
        Clears the database of all entries.

    Parameter(s):
        N/A

    Returns: nothing

    Example(s):
        call vgm_s_fnc_db_clear;
        
*/

{
	missionProfileNamespace setVariable [_x, nil];
} forEach allVariables missionProfileNamespace;