/*
    File: fn_missions_preInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2025-10-29
    Public: No

    Description:
        Prepares the mission system on the client for initialisation
 */

if (!hasInterface) exitWith {};

vgm_mission_onMission = false;
vgm_mission_givers = [];

["vgm_mission_creationFailed", {
    params ["_args"];
    _args params ["_reason", "_details"];

    if (_reason isEqualTo "ZONE_RESERVATION_FAILED") exitWith {
        hint format [localize "STR_VGM_MISSIONS_CREATION_ZONE_RESERVATION_FAILED", _targetZone];
    };

    hint format [localize "STR_VGM_MISSIONS_CREATION_UNKNOWN_ERROR", _reason];
}] call para_g_fnc_event_subscribeServer;
