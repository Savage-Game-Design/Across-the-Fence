/*
    File: fn_skills_addSkillPoint.sqf
    Author:
    Date: 2023-01-27
    Last Update: 2023-01-27
    Public: No

    Description:
        Give one skill point to player.

    Parameter(s):
        _player - Player to give the skill point to [OBJECT]
        _broadcast - Should the skill data be sent to the player [BOOL, defaults to false]

    Returns:
        Nothing

    Example(s):
        [player, true] call vgm_s_fnc_skills_addSkillPoint
 */

params ["_player", ["_broadcast", false]];

["INFO", format ["VGM: Adding skill point to %1 (%2)", name _player, getPlayerUID _player]] call para_g_fnc_log;

private _skillsData = _player call vgm_s_fnc_skills_dbGet;
private _skillPoints = _skillsData get "skillPoints";

_skillsData set ["skillPoints", _skillPoints + 1];

if (_broadcast) then {
    [_skillsData] remoteExecCall ["vgm_c_fnc_skills_receiveSkillsData", _player];
};
