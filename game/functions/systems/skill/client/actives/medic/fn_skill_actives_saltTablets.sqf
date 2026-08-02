/*
    File: fn_skill_actives_saltTablets.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Activates the "Salt tablets" skill.
        Restores stamina for the local player (runs on each group member
        via codeActivateGroup).

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_saltTablets
 */

["Salt tablets skill activated"] call vgm_g_fnc_logInfo;

player setFatigue 0;

[localize "STR_VGM_SKILLS_SKILL_SALT_TABLETS_ACTIVATED"] call para_c_fnc_hint;
