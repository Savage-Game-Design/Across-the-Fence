/*
    File: fn_suppression_preInit.sqf
    Author: Savage Game Design
    Date: 2024-04-03
    Last Update: 2025-01-17
    Public: No

    Description:
        PreInit for the suppression system.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
 */

["suppress", {
    params ["_unit", "_value"];
    [_unit, _value] call vgm_g_fnc_suppression_setShooterMultiplier;
}] call vgm_c_fnc_coefficient_create;
