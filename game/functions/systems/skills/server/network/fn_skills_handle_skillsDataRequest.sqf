/*
    File: fn_skills_handle_skillsDataRequest.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2023-01-27
    Public: No

    Description:
        Handle client skills data load request.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

params ["_player"];
["DEBUG", format ["VGM: Received player skills load request %1 (%2)", name _player, getPlayerUID _player]] call para_g_fnc_log;

private _skillsData = _player call vgm_s_fnc_skills_dbGet;

[_skillsData] remoteExecCall ["vgm_c_fnc_skills_receiveSkillsData", _player];
