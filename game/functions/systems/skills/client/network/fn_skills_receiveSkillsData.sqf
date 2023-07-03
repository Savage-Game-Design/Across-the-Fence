/*
    File: fn_skills_receiveSkillsData.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-06-02
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
    "Empty skills data" call vgm_g_fnc_logError;
};

["DEBUG", format ["Received skills data '%1'", _skillsData]] call vgm_g_fnc_log;

player setVariable ["vgm_g_skillsData", _skillsData];

private _knownSkillPathsList = _skillsData get "skillPaths";
{
    if (_x in _knownSkillPathsList) then {continue};
    ["DEBUG", format ["Skill not known anymore '%1'", _x]] call vgm_g_fnc_log;

    vgm_c_skills_appliedSkillsPaths = vgm_c_skills_appliedSkillsPaths - [_x];

    private _skill = _x call vgm_g_fnc_skills_getByPath;
    if (isNil "_skill") then {
        (format ["Skill does not exist '%1'", _x]) call vgm_g_fnc_logError;
        continue;
    };

    ["DEBUG", format ["Forgotten skill '%1'", _x]] call vgm_g_fnc_log;

    ["vgm_skills_forgotten", [_x, _skill]] call para_g_fnc_event_triggerLocal;

} forEach +vgm_c_skills_appliedSkillsPaths;

{
    private _skill = _x call vgm_g_fnc_skills_getByPath;
    if (isNil "_skill") then {
        (format ["Skill does not exist '%1'", _x]) call vgm_g_fnc_logError;
        continue;
    };

    if (_x in vgm_c_skills_appliedSkillsPaths) then {
        ["DEBUG", format ["Skill known previously '%1'", _x]] call vgm_g_fnc_log;
        continue;
    };

    ["DEBUG", format ["New skill '%1'", _x]] call vgm_g_fnc_log;

    vgm_c_skills_appliedSkillsPaths pushBack _x;
    ["vgm_skills_learnt", [_x, _skill]] call para_g_fnc_event_triggerLocal;

} forEach _knownSkillPathsList;
