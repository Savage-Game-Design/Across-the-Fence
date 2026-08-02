/*
    File: fn_skill_passives_warFace.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        When detected, stamina consumption is reduced by 30% for the next 30 seconds.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_warFace
 */

#define BUFF_DURATION 30
#define STAMINA_REDUCTION -0.3

params ["_known"];

if (!_known) exitWith {
    removeMissionEventHandler ["EachFrame", vgm_c_skill_passives_warFace_eh];
    [player, "staminaDrain", "skill_passives_warFace"] call vgm_c_fnc_coefficient_remove;
};

vgm_c_skill_passives_warFace_lastVisible = false;
vgm_c_skill_passives_warFace_buffEndTime = -1;

vgm_c_skill_passives_warFace_eh = addMissionEventHandler ["EachFrame", {
    private _isVisible = player getVariable ["vgm_g_stealth_isVisible", false];

    // Detect rising edge: was hidden, now visible (just detected)
    if (_isVisible && !vgm_c_skill_passives_warFace_lastVisible) then {
        [player, "staminaDrain", "skill_passives_warFace", STAMINA_REDUCTION, true] call vgm_c_fnc_coefficient_set;
        vgm_c_skill_passives_warFace_buffEndTime = time + BUFF_DURATION;
    };

    vgm_c_skill_passives_warFace_lastVisible = _isVisible;

    // Remove buff after duration expires
    if (vgm_c_skill_passives_warFace_buffEndTime > 0 && {time >= vgm_c_skill_passives_warFace_buffEndTime}) then {
        [player, "staminaDrain", "skill_passives_warFace"] call vgm_c_fnc_coefficient_remove;
        vgm_c_skill_passives_warFace_buffEndTime = -1;
    };
}];
