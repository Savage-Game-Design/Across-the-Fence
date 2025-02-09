/*
    File: fn_carry_canCarry.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2025-02-06
    Public: No

    Description:
        Check if unit can carry the target.

    Parameter(s):
        _unit   - Unit trying to carry [OBJECT]
        _target - Carried unit         [OBJECT]

    Returns:
        Can carry [BOOL]

    Example(s):
        [player, cursorObject] call vgm_c_fnc_carry_canCarry
 */

params ["_unit", "_target"];

!(alive _target != isAwake _target) // is not ragdolling
&& stance _unit != "PRONE"
&& (_target call vgm_g_fnc_medical_isUnconscious)
&& isNull attachedTo _target // return
