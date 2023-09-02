#include "script_component.inc"
/*
    File: fn_medical_updateVisuals.sqf
    Author: Savage Game Design
    Date: 2023-09-01
    Last Update: 2023-09-02
    Public: No

    Description:
        Update visual state of the hitpoints.

    Parameter(s):
        _unit -
        _bodyPart -
        _wounded -

    Returns:
        Something [BOOL]

    Example(s):
        [player, "body", true] call vgm_c_fnc_medical_updateVisuals
 */

// minimum damage needed for the character to make pain sounds and be able to bleed
#define INJURED_THRESHOLD 0.15
// Minimum damage needed on the hitpoint to show the blood texture
#define BLOOD_THRESHOLD 0.45

params ["_unit", "_bodyPart", "_wounded"];

private _hitPoint = createHashMapFromArray [
    [BODY_PART_HEAD, "HitHead"],
    [BODY_PART_ARMS, "HitHands"],
    [BODY_PART_TORSO, "HitBody"],
    [BODY_PART_LEGS, "HitLegs"]
] get _bodyPart;

_unit setHitPointDamage [_hitPoint, [0, BLOOD_THRESHOLD] select _wounded];

private _severeWounds = [_unit, "total"] call vgm_c_fnc_medical_getWound >= 2;
[_unit, [0, INJURED_THRESHOLD] select _severeWounds] call vgm_c_fnc_medical_setStructuralDamage;
