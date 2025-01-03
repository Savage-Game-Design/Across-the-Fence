/*
    File: fn_db_clear.sqf
    Author: Cerebral
    Date: 2022-11-11
    Last Update: 2024-12-19
    Public: No

    Description:
        Clears the database of all entries.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        call vgm_s_fnc_db_clear;

*/

{
	profileNamespace setVariable [_x, nil];
} forEach (allVariables profileNamespace select {_x find "vgm_" == 0});
