/*
    File: fn_compromisedLz_postInit.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Server postInit for the Compromised LZ system. Subscribes to mission
        lifecycle events to occupy LZs on mission start and clean up on end.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_s_fnc_compromisedLz_postInit;
*/

if (!isServer) exitWith {};

// When a mission starts, roll compromise for each LZ in the zone
["vgm_mission_started", {
    (_this#0) params ["_missionId"];
    [_missionId] call vgm_s_fnc_compromisedLz_occupyLzs;
}] call para_g_fnc_event_subscribeServer;

// When a mission ends, clean up all defenders for that mission
["vgm_mission_ended", {
    (_this#0) params ["_missionId"];
    [_missionId] call vgm_s_fnc_compromisedLz_cleanup;
}] call para_g_fnc_event_subscribeServer;

"VGM: Compromised LZ system postInit complete" call vgm_g_fnc_logInfo;
