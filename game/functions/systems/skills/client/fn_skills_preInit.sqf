/*
    File: fn_preInit.sqf
    Author: veteran29
    Date: 2022-12-16
    Last Update: 2022-12-18
    Public: No

    Description:
        Preinit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

#define SKILL_TIERS ["tier_1", "tier_2", "tier_3", "tier_4"]

private _fnc_parseSkillTree = {
    params ["_cfgSkillTree"];

    private _skillTree = createHashMapFromArray [
        ["displayName", getText (_cfgSkillTree >> "displayName")],
        ["skills", []]
    ];
    private _cfgSkills = _cfgSkillTree >> "skills";
    {
        private _cfgTier = _cfgSkills >> _x;
        if (isNull _cfgTier) exitWith {};

        private _skills = "true" configClasses _cfgTier apply {
            createHashMapFromArray [
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
            _subtrees set [configName _x, _x call _fnc_parseSkillTree];
        } forEach ("true" configClasses _cfgSubtrees);
    };

    _skillTree // return
};

private _cfgSkillTrees = missionConfigFile >> "vgm_skillTrees";

private _skillTrees = createHashMap;
{
    _skillTrees set [configName _x, _x call _fnc_parseSkillTree];
} forEach ("true" configClasses _cfgSkillTrees);

vgm_skills_treesHash = _skillTrees;
