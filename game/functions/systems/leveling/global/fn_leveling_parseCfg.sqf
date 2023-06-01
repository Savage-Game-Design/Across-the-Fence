/*
    File: fn_leveling_parseCfg.sqf
    Author: Savage Game Design
    Date: 2023-01-15
    Last Update: 2023-06-01
    Public: Yes

    Description:
        Parse leveling config into a HashMap.

    Parameter(s):
        _cfgSkillTrees - Skill trees config [CONFIG]

    Returns:
        Skill tree hash [HashMap]

    Example(s):
        [missionConfigFile >> "vgm_leveling"] call vgm_g_fnc_leveling_parseCfg
 */

params [
    ["_cfgLeveling", configNull, [configNull]]
];

private _fnc_parseLevel = {
    params ["_cfgLevel", "_index"];

    createHashMapFromArray [
        ["displayName", str _index],
        ["experience", getText (_cfgLevel >> "experience")],
        ["skillPoints", getText (_cfgLevel >> "skillPoints")]
    ] // return
};

private _skillTrees = createHashMap;
{
    _skillTrees set [_forEachIndex, [_x, _forEachIndex] call _fnc_parseLevel];
} forEach ("true" configClasses _cfgLeveling);

_skillTrees // return
