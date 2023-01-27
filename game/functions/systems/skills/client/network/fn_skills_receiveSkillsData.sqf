/*
    File: fn_skills_receiveSkillsData.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-01-27
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [_skillsData] call vgm_c_fnc_skills_receiveSkillsData
 */

params ["_skillsData"];

["DEBUG", format ["VGM: Received skills data '%1'", _skillsData]] call para_g_fnc_log;

player setVariable ["vgm_g_skillsData", _skillsData];

private _skillsCodeToApply = _skillsData get "skillsPaths" select {
    !(_x in vgm_c_skillsCodeApplied)
};

{
    private _skill = _x call vmg_g_skills_getSkillByPath;
    if (isNil "_skill") then {
        ["ERROR", format ["VGM: Skill does not exist '%1'", _x]] call para_g_fnc_log;
        continue;
    };

    ["DEBUG", format ["VGM: Applying skill callback '%1'", _x]] call para_g_fnc_log;

    player call (_skill get "codeApply");
    vgm_c_skillsCodeApplied set [_x, true];
} forEach _skillsCodeToApply;
