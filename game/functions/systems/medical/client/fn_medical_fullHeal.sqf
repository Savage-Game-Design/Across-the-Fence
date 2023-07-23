#include "script_component.inc"
/*
    File: fn_medical_fullHeal.sqf
    Author: Savage Game Design
    Date: 2023-07-01
    Last Update: 2023-07-23
    Public: Yes

    Description:
        Fully heal an unit. Should be used on local units only.

    Parameter(s):
        _unit - Unit to be fully healed [OBJECT]

    Returns:
        Nothing

    Example(s):
        player call vgm_c_fnc_medical_fullHeal
 */

params ["_unit"];

format ["Fully healing: %1", _unit] call vgm_g_fnc_logInfo;

{
    [_unit, _x, WOUND_MAX] call vgm_c_fnc_medical_removeWound;
} forEach BODY_PARTS_ARR;

nil
