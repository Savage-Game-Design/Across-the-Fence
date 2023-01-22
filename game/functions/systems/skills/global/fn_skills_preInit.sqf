/*
    File: fn_skills_preInit.sqf
    Author: veteran29
    Date: 2023-01-15
    Last Update: 2023-01-21
    Public: No

    Description:
        Global preinit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

vgm_skills_treesHash = [missionConfigFile >> "vgm_skillTrees"] call vgm_g_fnc_skills_parseTreeCfg;
