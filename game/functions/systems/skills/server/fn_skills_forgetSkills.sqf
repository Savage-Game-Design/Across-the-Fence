/*
    File: fn_skills_teachSkill.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-05-21
    Public: Yes

    Description:
        Make the player forget specified skills. Does not refund skill points.

    Parameter(s):
        _player - Player to give the skill point to [OBJECT]
        _skillPath - Paths to the skills being forgotten [ARRAY]

    Returns:
        Nothing

    Example(s):
        [player, ["utilityTree", "hiddenSkill"]] remoteExecCall ["vgm_s_fnc_skills_forgetSkills", 2];
 */

params ["_player", "_skillPaths"];

// handle single skill path
if (_skillPaths isEqualTypeParams ["", ""]) then {
    _skillPaths = [_skillPaths];
};

private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _knownSkillPaths = _skillsData get "skillPaths";
// remove skill path from known skills
{
    _knownSkillPaths deleteAt (_knownSkillPaths find _x);
} forEach _skillPaths;

[_player, _skillsData] call vgm_s_fnc_skills_dbSave;

[_skillsData] remoteExecCall ["vgm_c_fnc_skills_receiveSkillsData", _player];
