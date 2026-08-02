/*
    File: fn_radiocheckin_onCheckin.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Called on the server when a player completes a radio check-in.
        Finds the active mission, resets the check-in timer, and plays the
        voice line sequence (Columbia report → COVEY acknowledge).

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] remoteExecCall ["vgm_s_fnc_radiocheckin_onCheckin", 2];
*/

if (!isServer) exitWith {};

// Find the active mission
private _missions = localNamespace getVariable ["vgm_missions", createHashMap];
private _mission = objNull;
{
    if ((_y get "public") getOrDefault ["status", ""] == "IN PROGRESS") exitWith {
        _mission = _y;
    };
} forEach _missions;

if (_mission isEqualTo objNull) exitWith {
    "VGM RadioCheckIn: No active mission found for check-in" call vgm_g_fnc_logWarning;
};

// Reset timer
_mission set ["vgm_s_checkin_lastTime", serverTime];

// Radio transmission raises alertness — PAVN intercepts comms
private _missionId = (_mission get "public") get "id";
[_missionId] call vgm_s_fnc_director_onRadioTransmission;

// Play voice sequence via voicelines system with priority (bypasses category cooldown, 5s global)
["checkin", "report", false, objNull, true] call vgm_s_fnc_voicelines_play;
[6, "checkin", "acknowledge", false, objNull, true] call vgm_s_fnc_voicelines_playDelayed;

"VGM RadioCheckIn: Check-in completed, timer reset" call vgm_g_fnc_logInfo;
