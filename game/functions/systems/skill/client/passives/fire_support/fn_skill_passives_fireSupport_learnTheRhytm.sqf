/*
    File: fn_skill_passives_fireSupport_learnTheRhytm.sqf
    Author: Savage Game Design
    Date: 2023-10-07
    Last Update: 2023-10-08
    Public: No

    Description:
        Adds logic for Rifleman Tier 3 Learn the Rhytm skill.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_fireSupport_learnTheRhytm
 */

params ["_known"];

if (!_known) exitWith {
    player removeEventHandler ["Fired", vgm_c_skill_passives_fireSupport_learnTheRythm_firedEh];
    player removeEventHandler ["Reloaded", vgm_c_skill_passives_fireSupport_learnTheRythm_reloadedEh];
    removeUserActionEventHandler ["defaultAction", "Decativate", vgm_c_skill_passives_fireSupport_learnTheRythm_actionEh];
};

vgm_c_skill_passives_fireSupport_learnTheRythm_recoilCoef = 0;

// slowly decrease recoil with each shot fired
vgm_c_skill_passives_fireSupport_learnTheRythm_firedEh = player addEventHandler ["Fired", {
    private _coef = (vgm_c_skill_passives_fireSupport_learnTheRythm_recoilCoef - 0.01) max -0.5;
    vgm_c_skill_passives_fireSupport_learnTheRythm_recoilCoef = _coef;

    [player, 'recoil', 'skill_fireSupport_learnTheRythm', _coef] call vgm_c_fnc_coefficient_set;
}];

// reset recoil on reload
vgm_c_skill_passives_fireSupport_learnTheRythm_reloadedEh = player addEventHandler ["Reloaded", {
    vgm_c_skill_passives_fireSupport_learnTheRythm_recoilCoef = 0;
    [player, 'recoil', 'skill_fireSupport_learnTheRythm'] call vgm_c_fnc_coefficient_remove;
}];

// reset them trigger is not pressed anymore
vgm_c_skill_passives_fireSupport_learnTheRythm_actionEh = addUserActionEventHandler ["defaultAction", "Deactivate", {
    vgm_c_skill_passives_fireSupport_learnTheRythm_recoilCoef = 0;
    [player, 'recoil', 'skill_fireSupport_learnTheRythm'] call vgm_c_fnc_coefficient_remove;
}];
