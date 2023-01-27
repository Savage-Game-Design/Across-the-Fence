/*
    File: fn_skills_handle_skillLearnRequest.sqf
    Author:
    Date: 2023-01-27
    Last Update: 2023-01-27
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

    // send updated skills data to the client
    [_canLearn, nil, _skillPath] remoteExecCall ["vgm_c_fnc_skills_receiveSkillLearn", _player];
};


["SUCCESS", format ["VGM: Handling learn request for %1 (%2), %3", name _player, getPlayeRUID _player, _skillPath]] call para_g_fnc_log;

// add skill path to known skills
private _skillsData = _player call vgm_s_fnc_skills_dbGet;
_skillsData get "skillPaths" pushBackUnique _skillPath;

// decrease amount of skill points
private _skillPoints = _skillsData get "skillPoints";
_skillsData set ["skillPoints", _skillPoints - 1];

[_player, _skillsData] call vgm_s_fnc_skills_dbSave;

// send updated skills data to the client
[_canLearn, _skillsData, _skillPath] remoteExecCall ["vgm_c_fnc_skills_receiveSkillLearn", _player];
