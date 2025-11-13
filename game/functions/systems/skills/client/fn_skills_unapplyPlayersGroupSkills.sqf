/*
    File: fn_skills_unapplyPlayersGroupSkills.sqf
    Author: Savage Game Design
    Date: 2025-11-13
    Last Update: 2025-11-13
    Public: No

    Description:
        Removes the group effects of all skills owned by a given player.
        Called locally on the client where the effects should be removed.

    Parameter(s):
        _owningPlayerId - Player that owns the skill [STRING]

    Returns:
        Nothing

    Example(s):
        [getPlayerId _otherPlayer] call vgm_c_fnc_skills_unapplyPlayersGroupSkills;
 */

params ["_owningPlayerId"];

private _skills = values (vgm_c_skills_appliedGroupSkills getOrDefault [_owningPlayerId, createHashMap]);

{
    player call (_x get "codeUnapplyGroup");
} forEach _skills;

vgm_c_skills_appliedGroupSkills deleteAt _owningPlayerId;
vgm_c_skills_applyOnRespawnGroup deleteAt _owningPlayerId;
