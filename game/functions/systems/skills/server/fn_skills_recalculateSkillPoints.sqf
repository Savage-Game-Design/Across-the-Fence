/*
    File: fn_skills_recalculateSkillPoints.sqf
    Author: Savage Game Design
    Date: 2026-04-01
    Last Update: 2026-04-01
    Public: No

    Description:
        Recalculates a player's skillPointsSpent and skillPoints based on the discounted costs
        of all their known skills. Called when a tree discount changes to apply the discount
        retroactively.

    Parameter(s):
        _player - Player to recalculate for [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_player] call vgm_s_fnc_skills_recalculateSkillPoints;
 */

params ["_player"];

private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _skillPaths = _skillsData get "skillPaths";
private _totalEarned = (_skillsData get "skillPoints") + (_skillsData get "skillPointsSpent");

private _newSpent = 0;
{
    private _skill = _x call vgm_g_fnc_skills_getByPath;
    _newSpent = _newSpent + ([_skill, _player] call vgm_g_fnc_skills_getSkillCostForPlayer);
} forEach _skillPaths;

_skillsData set ["skillPointsSpent", _newSpent];
_skillsData set ["skillPoints", _totalEarned - _newSpent];

[_player, _skillsData] call vgm_s_fnc_skills_dbSave;
[_skillsData] remoteExecCall ["vgm_c_fnc_skills_receiveSkillsData", _player];
