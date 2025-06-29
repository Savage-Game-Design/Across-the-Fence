/*
    File: fn_skills_handle_skillsDataRequest.sqf
    Author: veteran29
    Date: 2023-01-27
    Last Update: 2025-06-29
    Public: No

    Description:
        Handle client skills data load request.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

params ["_player"];

if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {
    (format ["Skill data request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]) call vgm_g_fnc_logError;
};

["DEBUG", format ["Received player skills load request %1 (%2)", name _player, getPlayerUID _player]] call vgm_g_fnc_log;

[_player, {
    params ["_player", "_skillsData"];
    _player setVariable ["vgm_g_skillsData", _skillsData];
    [_skillsData] remoteExecCall ["vgm_c_fnc_skills_receiveSkillsData", _player];
}] call vgm_s_fnc_skills_dbGet;
