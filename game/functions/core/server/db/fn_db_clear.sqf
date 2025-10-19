/*
    File: fn_db_clear.sqf
    Author: Cerebral
    Date: 2022-11-11
    Last Update: 2025-10-18
    Public: No

    Description:
        Clears the database of all entries.

    Parameter(s):
        N/A

    Returns:
        DB was cleared [BOOL]

    Example(s):
        call vgm_s_fnc_db_clear;

*/

{
	profileNamespace setVariable [_x, nil];
} forEach (allVariables profileNamespace select {_x find "vgm_" == 0});

!isMultiplayer // allVariables profileNamespace does not work in MP
