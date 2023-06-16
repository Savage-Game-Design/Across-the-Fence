/*
    File: fn_skills_apply_hoofIt.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2023-05-21
    Public: No

    Description:
        Disables stamina for 30 seconds.

    Parameter(s):

    Returns:
        [BOOL] - Skill activated successfully.

    Example(s):
        call vgm_c_fnc_skills_apply_hoofIt;
 */

player enableStamina false;
systemChat "$STR_VGM_SKILLS_SKILL_RIFLEMAN_HOOFIT_APPLY";

[player] spawn {
    params ["_player"];

    sleep 30;
    systemChat "$STR_VGM_SKILLS_SKILL_RIFLEMAN_HOOFIT_UNAPPLY";
    _player enableStamina true;
    _player setFatigue 1;
};

