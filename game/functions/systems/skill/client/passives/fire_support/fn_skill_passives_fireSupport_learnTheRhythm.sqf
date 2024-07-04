/*
    File: fn_skill_passives_fireSupport_learnTheRhythm.sqf
    Author: Savage Game Design
    Date: 2023-10-07
    Last Update: 2024-07-04
    Public: No

    Description:
        Adds logic for Rifleman Tier 3 Learn the Rhythm skill.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_fireSupport_learnTheRhythm
 */

params ["_known"];

if (!_known) exitWith {
    player removeEventHandler ["Fired", vgm_c_skill_passives_fireSupport_learnTheRhythm_firedEh];
    player removeEventHandler ["Reloaded", vgm_c_skill_passives_fireSupport_learnTheRhythm_reloadedEh];
    removeUserActionEventHandler ["defaultAction", "Deactivate", vgm_c_skill_passives_fireSupport_learnTheRhythm_actionEh];
};

vgm_c_skill_passives_fireSupport_learnTheRhythm_recoilCoef = 0;

// slowly decrease recoil with each shot fired
vgm_c_skill_passives_fireSupport_learnTheRhythm_firedEh = player addEventHandler ["Fired", {
    private _coef = (vgm_c_skill_passives_fireSupport_learnTheRhythm_recoilCoef - 0.01) max -0.5;
    vgm_c_skill_passives_fireSupport_learnTheRhythm_recoilCoef = _coef;

    [player, 'recoil', 'skill_fireSupport_learnTheRhythm', _coef] call vgm_c_fnc_coefficient_set;
}];

// reset recoil on reload
vgm_c_skill_passives_fireSupport_learnTheRhythm_reloadedEh = player addEventHandler ["Reloaded", {
    vgm_c_skill_passives_fireSupport_learnTheRhythm_recoilCoef = 0;
    [player, 'recoil', 'skill_fireSupport_learnTheRhythm'] call vgm_c_fnc_coefficient_remove;
}];

// reset when trigger is not pressed anymore
vgm_c_skill_passives_fireSupport_learnTheRhythm_actionEh = addUserActionEventHandler ["defaultAction", "Deactivate", {
    vgm_c_skill_passives_fireSupport_learnTheRhythm_recoilCoef = 0;
    [player, 'recoil', 'skill_fireSupport_learnTheRhythm'] call vgm_c_fnc_coefficient_remove;
}];
