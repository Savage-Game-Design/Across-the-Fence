/*
    File: fn_skills_unapplyGroupSkill.sqf
    Author: Savage Game Design
    Date: 2025-11-13
    Last Update: 2025-11-14
    Public: No

    Description:
        Removes the group effects of a skill.
        Called locally on the client where the effect should be removed.

    Parameter(s):
        _skill - Skill to unapply [HashMap]
        _owningPlayerId - Player that owns the skill [STRING]

    Returns:
        Nothing

    Example(s):
        [[_path] call vgm_g_fnc_skills_getByPath, getPlayerId _otherPlayer] call vgm_c_fnc_skills_unapplyGroupSkill;
 */

params ["_skill", "_owningPlayerId"];

private _path = _skill get "path";
private _owningPlayerAppliedSkills = vgm_c_skills_appliedGroupSkills getOrDefault [_owningPlayerId, createHashMap];

if !(_path in _owningPlayerAppliedSkills) exitWith {
    [format ["Cannot unapply group skill: Player %1 isn't affected by player %2's skill %3", getPlayerID player, _owningPlayerId, _path]] call vgm_g_fnc_logWarning;
};

[format ["Unapplying group skill %1 from player %2", _path, _owningPlayerId]] call vgm_g_fnc_logDebug;

player call (_skill get "codeUnapplyGroup");

_owningPlayerAppliedSkills deleteAt _path;
vgm_c_skills_applyOnRespawnGroup getOrDefault [_owningPlayerId, createHashMap] deleteAt _path;
