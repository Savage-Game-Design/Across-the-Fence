/*
    File: fn_skills_handle_skillLearnRequest.sqf
    Author:
    Date: 2023-01-27
    Last Update: 2023-02-25
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]
 */

params ["_player", "_skillPath"];

private _skill = _skillPath call vgm_g_fnc_skills_getByPath;
private _canLearn = [_player, _skill] call vgm_g_fnc_skills_canLearn;

if (!_canLearn) exitWith {
    ["WARNING", format ["VGM: Discarding learn request for %1 (%2), %3", name _player, getPlayeRUID _player, _skillPath]] call para_g_fnc_log;

    // inform the player that he failed to learn the skill
    [_canLearn, _skillPath] remoteExecCall ["vgm_c_fnc_skills_receiveSkillLearn", _player];
};


["INFO", format ["VGM: Handling learn request for %1 (%2), %3", name _player, getPlayeRUID _player, _skillPath]] call para_g_fnc_log;

private _skill = _skillPath call vgm_g_fnc_skills_getByPath;

// decrease amount of skill points
private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _skillPoints = _skillsData get "skillPoints";
_skillsData set ["skillPoints", _skillPoints - (_skill get "cost")];

[_player, _skillPath] call vgm_s_fnc_skills_teachSkill;

// inform the player that he succeded to learn the skill
[_canLearn, _skillPath] remoteExecCall ["vgm_c_fnc_skills_receiveSkillLearn", _player];
