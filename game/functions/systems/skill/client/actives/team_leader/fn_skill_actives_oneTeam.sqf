/*
    File: fn_skill_actives_oneTeam.sqf
    Author: Savage Game Design
    Date: 2023-10-08
    Last Update: 2025-11-29
    Public: No

    Description:
        Resets the rest of the team's skill cooldowns.

    Parameter(s):
        _activatingUnit - Unit activating skill [UNIT]
        _skill - Skill being activated [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_oneTeam
 */

params ["_activatingUnit", "_skill"];

private _thisSkillPath = _skill get "path";

{
    private _skill = [_y] call vgm_c_fnc_skills_active_getSlotSkill;
    if (_skill getOrDefault ["path", []] isNotEqualTo _thisSkillPath) then {
        [_y] call vgm_c_fnc_skills_active_resetSlotCooldown;
    };
} forEach vgm_c_skills_active_slots;
