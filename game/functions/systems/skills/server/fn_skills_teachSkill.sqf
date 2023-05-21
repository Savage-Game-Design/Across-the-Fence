/*
    File: fn_skills_teachSkill.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-05-21
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

params ["_player", "_skillPath"];

// add skill path to known skills
private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
_skillsData get "skillPaths" pushBackUnique _skillPath;

[_player, _skillsData] call vgm_s_fnc_skills_dbSave;

[_skillsData] remoteExecCall ["vgm_c_fnc_skills_receiveSkillsData", _player];
