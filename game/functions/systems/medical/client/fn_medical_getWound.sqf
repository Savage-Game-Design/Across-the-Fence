#include "script_component.inc"
/*
    File: fn_medical_getWound.sqf
    Author: Savage Game Design
    Date: 2023-07-06
    Last Update: 2023-07-07
    Public: No

    Description:
        Get wound level of unit body part.
        Use special body part "total" to get sum of all wounds.

    Parameter(s):
        _unit - Unit to get the wound level from [OBJECT]
        _bodyPart - Body part to get the wound level from [OBJECT]

    Returns:
        Wound level [NUMBER]

    Example(s):
        [player, "torso"] call vgm_c_fnc_medical_getWound
 */

params ["_unit", "_bodyPart"];

if (_bodyPart == "total") exitWith {
    private _sum = 0;
    {
        _sum = _sum + (_unit getVariable [format ["vgm_g_medical_wound$%1", _x], 0]);
    } forEach BODY_PARTS_ARR;

    _sum // return
};

_unit getVariable [format ["vgm_g_medical_wound$%1", _bodyPart], 0] // return
