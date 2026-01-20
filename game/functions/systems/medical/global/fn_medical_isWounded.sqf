#include "script_component.inc"
/*
    File: fn_medical_isWounded.sqf
    Author: Savage Game Design
    Date: 2026-01-11
    Last Update: 2026-01-20
    Public: Yes

    Description:
        Check if unit is wounded.
        Does not work for vanilla medical system.

    Parameter(s):
        _unit - Unit to check [OBJECT]

    Returns:
        Is wounded [BOOL]

    Example(s):
        [player] call vgm_g_fnc_medical_isWounded;
 */

params ["_unit"];

BODY_PARTS_ARR findIf {
    (_unit getVariable [format ["vgm_g_medical_wound$%1", _x], WOUND_NONE]) > WOUND_NONE // return
} > -1 // return
