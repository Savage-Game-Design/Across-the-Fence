/*
    File: fn_skills_active_applyGroupSkill.sqf
    Author: Savage Game Design
    Date: 2025-11-29
    Last Update: 2025-11-29
    Public: No

    Description:
        Applies the effects of an active skill to a group member ("codeActivateGroup")

    Parameter(s):
        _triggeringPlayer - Player that triggered the skill [UNIT]
        _skillPath - Path of the skill [ARRAY]

    Returns:
        Nothing

    Example(s):
        [player, _skill get "path"] remoteExec ["vgm_c_fnc_skills_active_applyGroupSkill", [] call vgm_c_fnc_missions_getTeamMembers];
 */

params ["_triggeringPlayer", "_skillPath"];

private _skill = _skillPath call vgm_g_fnc_skills_getByPath;

[_triggeringPlayer, _skill] call (_skill get "codeActivateGroup")
