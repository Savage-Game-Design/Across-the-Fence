#include "script_component.inc"
/*
    File: fn_medical_shouldBleed.sqf
    Author: Savage Game Design
    Date: 2023-07-23
    Last Update: 2023-07-23
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

// start bleeding when Arms or Legs are severly damaged or all body parts total damage is >= 6
WOUND_MAX in ([BODY_PART_ARMS, BODY_PART_LEGS] apply {[_unit, _x] call vgm_c_fnc_medical_getWound})
|| {([_unit, "total"] call vgm_c_fnc_medical_getWound) >= WOUNDS_BLEED_THRESHOLD}
