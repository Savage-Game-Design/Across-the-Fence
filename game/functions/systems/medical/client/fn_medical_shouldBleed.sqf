#include "script_component.inc"
/*
    File: fn_medical_shouldBleed.sqf
    Author: Savage Game Design
    Date: 2023-07-23
    Last Update: 2024-07-09
    Public: No

    Description:
        Check if unit should be bleeding.

    Parameter(s):
        _unit - Unit to check [OBJECT]

    Returns:
        Should bleed [BOOL]

    Example(s):
        player call vgm_c_fnc_medical_shouldBleed
 */

params ["_unit"];

// start bleeding when any body part suffered major damage or all body parts total damage is >= 3
(BODY_PARTS_ARR findIf {[_unit, _x] call vgm_c_fnc_medical_getWound >= WOUND_MAJOR} != -1)
|| {([_unit, "total"] call vgm_c_fnc_medical_getWound) >= WOUNDS_BLEED_THRESHOLD}
