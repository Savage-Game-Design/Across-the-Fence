/*
    File: fn_director_onRadioTransmission.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Called when a player uses the radio (check-in, extraction request,
        RTO skills, etc.). Raises mission alertness by 5. PAVN intercepts
        all radio transmissions but a brief check-in is harder to triangulate.

    Parameter(s):
        _missionId - ID of the active mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        Server:  [_missionId] call vgm_s_fnc_director_onRadioTransmission;
        Client:  [group player getVariable "vgm_g_missionId"] remoteExecCall ["vgm_s_fnc_director_onRadioTransmission", 2];
 */

params ["_missionId"];

if (!isServer) exitWith {};

private _director = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;

if (isNil "_director") exitWith {
    format ["Director: Radio transmission ignored — no director for mission %1", _missionId] call vgm_g_fnc_logWarning;
};

[_director, 5] call vgm_s_fnc_director_addAlertness;

format ["Director: Radio transmission intercepted — +5 alertness (mission %1)", _missionId] call vgm_g_fnc_logInfo;
