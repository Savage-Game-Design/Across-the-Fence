/*
    File: fn_skills_preInit.sqf
    Author: veteran29
    Date: 2023-01-15
    Last Update: 2023-01-22
    Public: No

    Description:
        Global preinit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

vgm_skills_treesHash = [missionConfigFile >> "vgm_skillTrees"] call vgm_g_fnc_skills_parseTreeCfg;
vgm_skills_pathsHash = [vgm_skills_treesHash] call vgm_g_fnc_skills_treesHashToPathsHash;
