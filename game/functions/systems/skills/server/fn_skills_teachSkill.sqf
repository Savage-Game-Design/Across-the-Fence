/*
    File: fn_skills_teachSkill.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2025-06-29
    Public: Yes

    Description:
        Teach the skill to the player.

    Parameter(s):
        _player - Player to give the skill point to [OBJECT]
        _skillPath - Path to the skill being taught [ARRAY]

    Returns:
        Nothing

    Example(s):
        [player, ["utilityTree", "hiddenSkill"]] remoteExecCall ["vgm_s_fnc_skills_teachSkill", 2];
 */

params ["_player", "_skillPath", "_callback"];

// add skill path to known skills
private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
_skillsData get "skillPaths" pushBackUnique _skillPath;

[_player, _skillsData, [{
    params ["_player", "", "_skillsData", "_callback"];
    [_skillsData] remoteExecCall ["vgm_c_fnc_skills_receiveSkillsData", _player];

    _callback params ["_callback", "_arguments"];
    [_player, _skillsData, _arguments] call _callback;
}, _callback]] call vgm_s_fnc_skills_dbSave;
