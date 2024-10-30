/*
    File: fn_sites_hints_preInit.sqf
    Author: Savage Game Design
    Date: 2024-10-27
    Last Update: 2024-10-30
    Public: No

    Description:
        Client Preinit for the site hints system.
 */

if (!hasInterface) exitWith {};

vgm_sites_hints_objectsList = [];

["vgm_mission_ended", {
    vgm_sites_hints_objectsList = [];
}] call para_g_fnc_event_subscribeServer;
