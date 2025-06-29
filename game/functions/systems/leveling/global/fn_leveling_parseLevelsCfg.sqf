/*
    File: fn_leveling_parseLevelsCfg.sqf
    Author: Savage Game Design
    Date: 2023-01-15
    Last Update: 2025-06-29
    Public: Yes

    Description:
        Parse levels config into a HashMap.

    Parameter(s):
        _cfgLevels - Levels config [CONFIG]

    Returns:
        Skill tree hash [HashMap]

    Example(s):
        [missionConfigFile >> "vgm_levels"] call vgm_g_fnc_leveling_parseCfg
 */

params [
    ["_cfgLevels", configNull, [configNull]]
];

if (isNull _cfgLevels) exitWith {
    ["Leveling config is null"] call vgm_g_fnc_logError;
    createHashMap
};

private _levels = createHashMap;
private _experienceThreshold = 0;
private _totalSkillPoints = 0;

private _fnc_parseLevel = {
    params ["_cfgLevel", "_index", "_experienceThreshold"];

    createHashMapFromArray [
        ["displayName", str _index],
        ["experience", getNumber (_cfgLevel >> "experience")],
        ["experienceThreshold", _experienceThreshold + getNumber (_cfgLevel >> "experience")],
        ["skillPoints", getNumber (_cfgLevel >> "skillPoints")],
        ["totalSkillPoints", _totalSkillPoints + getNumber (_cfgLevel >> "skillPoints")]
    ] // return
};

{
    private _level = [_x, _forEachIndex, _experienceThreshold] call _fnc_parseLevel;

    _experienceThreshold = _experienceThreshold + (_level get "experience");
    _totalSkillPoints = _level get "totalSkillPoints";
    _levels set [_forEachIndex, _level];
} forEach ("true" configClasses _cfgLevels);

_levels // return
