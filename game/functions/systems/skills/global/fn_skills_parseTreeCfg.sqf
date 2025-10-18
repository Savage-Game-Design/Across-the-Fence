/*
    File: fn_skills_parseTreeCfg.sqf
    Author:
    Date: 2023-01-15
    Last Update: 2025-10-18
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

if (isNull _cfgSkillTrees) exitWith {
    ["Skill trees config is null"] call vgm_g_fnc_logError;
    createHashMap
};

#define SKILL_TIERS ["tier_0", "tier_1", "tier_2", "tier_3", "tier_4"]

private _fnc_parseSkillTree = {
    params ["_cfgSkillTree", ["_path", []]];
    _path pushBack configName _cfgSkillTree;

    private _skillTree = createHashMapFromArray [
        ["path", _path],
        ["displayName", getText (_cfgSkillTree >> "displayName")],
        ["icon", getText (_cfgSkillTree >> "icon")],
        ["description", getText (_cfgSkillTree >> "description")],
        ["skills", []],
        ["skillPointsMax", 0]
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
                ["displayName", getText (_x >> "displayName")],
                ["description", getText (_x >> "description")],
                ["column", getNumber (_x >> "column")],
                ["icon", getText (_x >> "icon")],
                ["isActive", getNumber (_x >> "skillType") > 0],
                ["applyOnRespawn", getNumber (_x >> "applyOnRespawn") > 0],
                ["cooldown", getNumber (_x >> "cooldown")],
                ["duration", getNumber (_x >> "duration")],
                ["cost", getNumber (_x >> "cost")],
                ["conditionsUnlockServer", getArray (_x >> "conditionsUnlockServer") apply {
                    _x params [["_code", "true"], ["_reason", ""]];
                    [ compileFinal _code, _reason ]
                }],
                ["conditionShow", compileFinal getText (_x >> "conditionShow")],
                ["conditionActivate", compileFinal getText (_x >> "conditionActivate")],
                ["codeApply", compileFinal getText (_x >> "codeApply")],
                ["codeUnapply", compileFinal getText (_x >> "codeUnapply")],
                ["codeActivate", compileFinal getText (_x >> "codeActivate")],
                ["codeDeactivate", compileFinal getText (_x >> "codeDeactivate")],
                ["codeUnableToActivate", compileFinal getText (_x >> "codeUnableToActivate")]
            ];
        };

        private _skillPointsMax = _skillTree get "skillPointsMax";
        {
            _skillPointsMax = _skillPointsMax + (_x get "cost");
        } forEach _skills;
        _skillTree set ["skillPointsMax", _skillPointsMax];

        _skillTree get "skills" pushBack _skills;
    } forEach SKILL_TIERS;

    // recurse on subtrees
    private _cfgSubtrees = _cfgSkillTree >> "subtrees";
    if (!isNull _cfgSubtrees) then {
        private _subtrees = createHashMap;
        _skillTree set ["subtreesHash", _subtrees];

        {
            _subtrees set [configName _x, [_x, +_path] call _fnc_parseSkillTree];
        } forEach ("true" configClasses _cfgSubtrees);
    };

    _skillTree // return
};

private _skillTrees = createHashMap;
{
    _skillTrees set [configName _x, _x call _fnc_parseSkillTree];
} forEach ("true" configClasses _cfgSkillTrees);

_skillTrees // return
