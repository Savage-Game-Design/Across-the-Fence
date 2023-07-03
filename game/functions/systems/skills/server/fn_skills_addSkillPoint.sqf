/*
    File: fn_skills_addSkillPoint.sqf
    Author:
    Date: 2023-01-27
    Last Update: 2023-06-01
    Public: No

    Description:
        Give one skill point to player.

    Parameter(s):
        _player - Player to give the skill point to [OBJECT]
        _amount - Amount of skills points to add to player [NUMBER, defaults to 1]

    Returns:
        Nothing

    Example(s):
        [player, 2] call vgm_s_fnc_skills_addSkillPoint
 */

params ["_player", ["_amount", 1]];

(format ["Adding %3 skill points to %1 (%2)", name _player, getPlayerUID _player, _amount]) call vgm_g_fnc_logInfo;

private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _skillPoints = _skillsData get "skillPoints";

_skillsData set ["skillPoints", _skillPoints + _amount];

[_player, _skillsData] call vgm_s_fnc_skills_dbSave;

[_skillsData] remoteExecCall ["vgm_c_fnc_skills_receiveSkillsData", _player];
