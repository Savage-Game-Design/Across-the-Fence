/*
    File: fn_db_profile_clear.sqf
    Author: Savage Game Design
    Date: 2025-06-29
    Last Update: 2025-06-29
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

{
	profileNamespace setVariable [_x, nil];
} forEach (allVariables profileNamespace select {_x find "vgm_" == 0});
