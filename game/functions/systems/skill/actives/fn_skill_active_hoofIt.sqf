/*
    File: fn_skill_active_hoofIt.sqf
    Author: Savage Game Design
    Date: 2023-05-20
    Last Update: 2023-06-17
    Public: No

    Description:
        Disables stamina for 30 seconds.

    Parameter(s):

    Returns:
        [BOOL] - Skill activated successfully.

    Example(s):
        call vgm_c_fnc_skill_active_hoofIt;
 */

player enableStamina false;
systemChat localize "STR_VGM_SKILLS_SKILL_RIFLEMAN_HOOFIT_APPLY";

[player] spawn {
    params ["_player"];

    sleep 30;
    systemChat localize "STR_VGM_SKILLS_SKILL_RIFLEMAN_HOOFIT_UNAPPLY";
    _player enableStamina true;
    _player setFatigue 1;
};

