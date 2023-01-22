/*
    File: fn_preInit.sqf
    Author: veteran29
    Date: 2022-12-16
    Last Update: 2023-01-22
    Public: No

    Description:
        Client preInit function for skills system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

// TODO available skill points could be calculated in function
// eg. PLAYER_LEVEL - KNOWN_SKILLS_COST or smth.
// needs actual player level/profile API
vgm_skills_points = 0;

vgm_skills_knownSkills = createHashMap;
