/*
    File: fn_skills_receiveSkillsData.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-05-14
    Public: No

    Description:
        Handle receiving skills data from the server.

    Parameter(s):
        _skillsData - Skills data hash [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_skillsData] call vgm_c_fnc_skills_receiveSkillsData
 */

params ["_skillsData"];

if (isNil "_skillsData") exitWith {
    ["ERROR", "VGM: Empty skills data"] call para_g_fnc_log;
};

["DEBUG", format ["VGM: Received skills data '%1'", _skillsData]] call para_g_fnc_log;

player setVariable ["vgm_g_skillsData", _skillsData];

private _knownSkillPathsList = _skillsData get "skillPaths";
{
    if (_x in _knownSkillPathsList) then {continue};
    ["DEBUG", format ["VGM: Skill not known anymore '%1'", _x]] call para_g_fnc_log;

    vgm_c_skills_appliedSkillsPaths = vgm_c_skills_appliedSkillsPaths - [_x];

    private _skill = _x call vgm_g_fnc_skills_getByPath;
    if (isNil "_skill") then {
        ["ERROR", format ["VGM: Skill does not exist '%1'", _x]] call para_g_fnc_log;
        continue;
    };

    ["DEBUG", format ["VGM: Forgotten skill '%1'", _x]] call para_g_fnc_log;

    ["vgm_skills_forgotten", [_x, _skill]] call para_g_fnc_event_triggerLocal;

} forEach +vgm_c_skills_appliedSkillsPaths;

{
    private _skill = _x call vgm_g_fnc_skills_getByPath;
    if (isNil "_skill") then {
        ["ERROR", format ["VGM: Skill does not exist '%1'", _x]] call para_g_fnc_log;
        continue;
    };

    if (_x in vgm_c_skills_appliedSkillsPaths) then {
        ["DEBUG", format ["VGM: Skill known previously '%1'", _x]] call para_g_fnc_log;
        continue;
    };

    ["DEBUG", format ["VGM: New skill '%1'", _x]] call para_g_fnc_log;

    vgm_c_skills_appliedSkillsPaths pushBack _x;
    ["vgm_skills_learnt", [_x, _skill]] call para_g_fnc_event_triggerLocal;

} forEach _knownSkillPathsList;
