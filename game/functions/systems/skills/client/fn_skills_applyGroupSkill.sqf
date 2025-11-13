/*
    File: fn_skills_applyGroupSkill.sqf
    Author: Savage Game Design
    Date: 2025-11-13
    Last Update: 2025-11-14
    Public: No

    Description:
        Sets up the group effects of a skill.
        Should be called locally on each player in the group where the skill is active.

    Parameter(s):
        _skill - Skill to apply [HashMap]
        _owningPlayerId - Player that owns the skill [STRING]

    Returns:
        Nothing

    Example(s):
        [[_path] call vgm_g_fnc_skills_getByPath, getPlayerId _otherPlayer] call vgm_c_fnc_skills_applyGroupSkill;
 */

params ["_skill", "_owningPlayerId"];

private _path = _skill get "path";
private _owningPlayerAppliedSkills = vgm_c_skills_appliedGroupSkills getOrDefault [_owningPlayerId, createHashMap, true];

if (_path in _owningPlayerAppliedSkills) exitWith {
    [format ["Skill %1 already applied for player %2", _path, _owningPlayerId]] call vgm_g_fnc_logWarning;
};

[format ["Applying group skill %1 from player %2", _path, _owningPlayerId]] call vgm_g_fnc_logDebug;

player call (_skill get "codeApplyGroup");

_owningPlayerAppliedSkills set [_path, _skill];

if (_skill get "applyOnRespawnGroup") then {
    vgm_c_skills_applyOnRespawnGroup getOrDefault [_owningPlayerId, createHashMap, true] set [_path, _skill];
};
