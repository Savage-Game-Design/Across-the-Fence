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

// TODO server side validation?
private _result = true;

["DEBUG", format ["VGM: Handling learn request for %1 (%2)", name _player, getPlayeRUID _player]] call para_g_fnc_log;

private _skillsData = _player call vgm_s_fnc_skills_dbGet;
_skillsData get "skillPaths" pushBackUnique _skillPath;

[_player, _skillsData] call vgm_s_fnc_skills_dbSave;

// send updated skills data to the client
[_result, _skillsData, _skillPath] remoteExecCall ["vgm_c_fnc_skills_receiveSkillLearn", _player];

