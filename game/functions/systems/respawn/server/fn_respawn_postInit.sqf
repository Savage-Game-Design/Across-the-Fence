/*
    File: fn_respawn_postInit.sqf
    Author: Savage Game Design
    Date: 2025-12-03
    Last Update: 2025-12-03
    Public: No

    Description:
        Post-init for respawn on the server
 */

if (!isServer) exitWith {};

["vgm_mission_available", {
    (_this#0) params ["_missionId"];
    [_missionId, "respawn"] call vgm_s_fnc_missions_createSystemNetmap;
}] call para_g_fnc_event_subscribeServer;
