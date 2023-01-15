/*
    File: fn_skills_parseTreeCfg.sqf
    Author:
    Date: 2023-01-15
    Last Update: 2023-01-15
    Public: Yes

    Description:
        Parse skill tree config into a HashMap.

    Parameter(s):
        _cfgSkillTrees - Skill trees config [CONFIG]

    Returns:
        Skill tree hash [HashMap]

    Example(s):
        [missionConfigFile >> "vgm_skillTrees"] call vgm_g_fnc_skills_parseTreeCfg
 */

params [
    ["_cfgSkillTrees", configNull, [configNull]]
];

#define SKILL_TIERS ["tier_1", "tier_2", "tier_3", "tier_4"]

private _fnc_parseSkillTree = {
    params ["_cfgSkillTree", ["_path", []]];
    _path pushBack configName _cfgSkillTree;

    private _skillTree = createHashMapFromArray [
        ["displayName", getText (_cfgSkillTree >> "displayName")],
        ["skills", []]
    ];
    private _cfgSkills = _cfgSkillTree >> "skills";
    {
        private _cfgTier = _cfgSkills >> _x;
        if (isNull _cfgTier) exitWith {};

        private _tier = _forEachIndex;
        private _skills = "true" configClasses _cfgTier apply {
            createHashMapFromArray [
                ["path", _path + [configName _x]],
                ["tier", _tier],
                ["cost", 1],
                ["displayName", getText (_x >> "displayName")],
                ["description", getText (_x >> "description")],
                ["icon", getText (_x >> "icon")],
                ["isActive", getNumber (_x >> "isActive") > 0],
                ["applyOnRespawn", getNumber (_x >> "applyOnRespawn") > 0],
                ["conditionUnlock", compileFinal getText (_x >> "conditionUnlock")],
                ["codeApply", compileFinal getText (_x >> "codeApply")],
                ["codeActivate", compileFinal getText (_x >> "codeActivate")]
            ];
        };

        _skillTree get "skills" pushBack _skills;
    } forEach SKILL_TIERS;

    // recurse on subtrees
    private _cfgSubtrees = _cfgSkillTree >> "subtrees";
    if (!isNull _cfgSubtrees) then {
        private _subtrees = createHashMap;
        _skillTree set ["subtrees", _subtrees];

        {
            _subtrees set [configName _x, [_x, _path] call _fnc_parseSkillTree];
        } forEach ("true" configClasses _cfgSubtrees);
    };

    _skillTree // return
};

private _skillTrees = createHashMap;
{
    _skillTrees set [configName _x, _x call _fnc_parseSkillTree];
} forEach ("true" configClasses _cfgSkillTrees);

_skillTrees // return
