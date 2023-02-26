/*
    File: fn_skills_teachSkill.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-02-25
    Public: Yes

    Description:
        Make the player forget specified skill.

    Parameter(s):
        _player - Player to give the skill point to [OBJECT]
        _skillPath - Path to the skill being forgotten [ARRAY]

    Returns:
        Nothing

    Example(s):
        [player, ["utilityTree", "hiddenSkill"]] remoteExecCall ["vgm_s_fnc_skills_forgetSkill", 2];
 */

params ["_player", "_skillPath"];

// remove skill path from known skills
private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _skillPaths = _skillsData get "skillPaths";
_skillPaths deleteAt (_skillPaths find _skillPath);

[_player, _skillsData] call vgm_s_fnc_skills_dbSave;

[_skillsData] remoteExecCall ["vgm_c_fnc_skills_receiveSkillsData", _player];
