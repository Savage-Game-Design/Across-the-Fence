/*
    File: fn_missions_preInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2024-04-04
    Public: No

    Description:
        Prepares the mission system on the client for initialisation
 */

if (!hasInterface) exitWith {};

["vgm_mission_creationFailed", {
    params ["_args"];
    _args params ["_targetZone"];

    hint format ["Failed to reserve zone %1 for mission.", markerText _targetZone];
}] call para_g_fnc_event_subscribeServer;
