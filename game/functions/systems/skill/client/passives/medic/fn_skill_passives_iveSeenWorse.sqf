/*
    File: fn_skill_passives_iveSeenWorse.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Reduces the effects of limb injuries on yourself. When arms or legs
        have wounds, applies flat counter-coefficients at 50% of the minor
        debuff values to offset injury penalties.

    Parameter(s):
        _apply - Should skill effect be applied? [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_iveSeenWorse
 */

params ["_apply"];

if (!_apply) exitWith {
    if (!isNil "vgm_c_skill_passives_iveSeenWorse_woundAddedEH") then {
        [vgm_c_skill_passives_iveSeenWorse_woundAddedEH] call para_g_fnc_event_unsubscribe;
    };
    if (!isNil "vgm_c_skill_passives_iveSeenWorse_woundRemovedEH") then {
        [vgm_c_skill_passives_iveSeenWorse_woundRemovedEH] call para_g_fnc_event_unsubscribe;
    };

    // Remove all counter-coefficients
    {
        [player, _x, "skill_iveSeenWorse"] call vgm_c_fnc_coefficient_remove;
    } forEach ["recoil", "aim", "throw", "interact"];
};

private _fnc_updateCounters = {
    params ["_unit"];
    if (_unit != player) exitWith {};

    private _armsWound = _unit getVariable ["vgm_g_medical_wound$arms", 0];
    private _legsWound = _unit getVariable ["vgm_g_medical_wound$legs", 0];
    private _hasLimbWounds = _armsWound > 0 || _legsWound > 0;

    if (_hasLimbWounds) then {
        // Counter 50% of minor arm debuffs: recoil 0.5 -> -0.25, aim 0.5 -> -0.25, throw -0.4 -> +0.2, interact 0.25 -> -0.125
        [player, "recoil", "skill_iveSeenWorse", -0.25] call vgm_c_fnc_coefficient_set;
        [player, "aim", "skill_iveSeenWorse", -0.25] call vgm_c_fnc_coefficient_set;
        [player, "throw", "skill_iveSeenWorse", 0.2] call vgm_c_fnc_coefficient_set;
        [player, "interact", "skill_iveSeenWorse", -0.125] call vgm_c_fnc_coefficient_set;
    } else {
        {
            [player, _x, "skill_iveSeenWorse"] call vgm_c_fnc_coefficient_remove;
        } forEach ["recoil", "aim", "throw", "interact"];
    };
};

vgm_c_skill_passives_iveSeenWorse_woundAddedEH = ["vgm_medical_woundAdded", {
    (_this#0) params ["_unit", "_bodyPart"];
    if (_bodyPart in ["arms", "legs"]) then {
        [_unit] call vgm_c_skill_passives_iveSeenWorse_fnc_update;
    };
}] call para_g_fnc_event_subscribe;

vgm_c_skill_passives_iveSeenWorse_woundRemovedEH = ["vgm_medical_woundRemoved", {
    (_this#0) params ["_unit", "_bodyPart"];
    if (_bodyPart in ["arms", "legs"]) then {
        [_unit] call vgm_c_skill_passives_iveSeenWorse_fnc_update;
    };
}] call para_g_fnc_event_subscribe;

vgm_c_skill_passives_iveSeenWorse_fnc_update = _fnc_updateCounters;
