/*
    File: fn_preInit.sqf
    Author: veteran29
    Date: 2022-12-16
    Last Update: 2023-01-15
    Public: No

    Description:
        Client preinit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

vgm_skills_points = 0;

vgm_skills_knownSkills = createHashMap;
