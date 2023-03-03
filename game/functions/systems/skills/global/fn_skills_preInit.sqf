/*
    File: fn_skills_preInit.sqf
    Author: veteran29
    Date: 2023-01-15
    Last Update: 2023-02-25
    Public: No

    Description:
        Global preinit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

vgm_skills_treesHashMap = [missionConfigFile >> "vgm_skillTrees"] call vgm_g_fnc_skills_parseTreeCfg;
vgm_skills_pathsHashMap = [vgm_skills_treesHashMap] call vgm_g_fnc_skills_treesHashToPathsHash;
