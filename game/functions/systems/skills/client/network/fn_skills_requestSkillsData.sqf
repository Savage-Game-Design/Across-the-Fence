/*
    File: fn_skills_requestSkillsData.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-02-28
    Public: No

    Description:
        Request local player skills data from server.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skills_requestSkillsData
 */

["DEBUG", "VGM: Requesting skills data"] call para_g_fnc_log;

[player] remoteExecCall ["vgm_s_fnc_skills_handle_skillsDataRequest", 2];
