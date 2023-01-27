/*
    File: fn_skills_getSkillPoints.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-01-27
    Public: No

    Description:
        Get amount of available skillpoints.

    Parameter(s):
        N/A

    Returns:
        Skill points [NUMBER]

    Example(s):
        [] call vgm_c_fnc_getSkillPoints
 */

(player getVariable "vgm_g_skillsData") get "skillPoints"
