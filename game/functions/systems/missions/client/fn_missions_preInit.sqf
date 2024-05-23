/*
    File: fn_missions_preInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2024-05-23
    Public: No

    Description:
        Prepares the mission system on the client for initialisation
 */

if (!hasInterface) exitWith {};

["vgm_mission_started", {
    vgm_mission_onMission = true;
}] call para_g_fnc_event_subscribeLocal;

["vgm_mission_ended", {
    vgm_mission_onMission = false;
}] call para_g_fnc_event_subscribeLocal;
