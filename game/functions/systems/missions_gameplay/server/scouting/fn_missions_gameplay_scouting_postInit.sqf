/*
    File: fn_mission_gameplay_scouting_postInit.sqf
    Author: Savage Game Design
    Date: 2024-08-09
    Last Update: 2024-08-18
    Public: No

    Description:
        Server Post init for mission gameplay scouting system.
 */

if (!isServer) exitWith {};

["vgm_mission_available", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_scouting_registerMission;
}] call para_g_fnc_event_subscribeServer;

["vgm_sites_siteSpawned", {
    (_this#0) params ["_site"];

    {
        if (_x isKindOf "Land_vn_vegetation_base") then {continue};
        [_x, _site] call vgm_s_fnc_missions_gameplay_scouting_setSpottable;
    } forEach (_site get "objects");
}] call para_g_fnc_event_subscribeServer;

["vgm_scouting_spottedTarget", {
    (_this#0) params ["_spotter", "_target"];
    [_spotter, _target] call vgm_s_fnc_missions_gameplay_scouting_handleSpotted;
}] call para_g_fnc_event_subscribeServer;
