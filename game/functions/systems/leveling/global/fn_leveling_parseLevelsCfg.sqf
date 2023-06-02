/*
    File: fn_leveling_parseLevelsCfg.sqf
    Author: Savage Game Design
    Date: 2023-01-15
    Last Update: 2023-06-02
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

private _fnc_parseLevel = {
    params ["_cfgLevel", "_index"];

    createHashMapFromArray [
        ["displayName", str _index],
        ["experience", getNumber (_cfgLevel >> "experience")],
        ["skillPoints", getNumber (_cfgLevel >> "skillPoints")]
    ] // return
};

private _skillTrees = createHashMap;
{
    _skillTrees set [_forEachIndex, [_x, _forEachIndex] call _fnc_parseLevel];
} forEach ("true" configClasses _cfgLevels);

_skillTrees // return
