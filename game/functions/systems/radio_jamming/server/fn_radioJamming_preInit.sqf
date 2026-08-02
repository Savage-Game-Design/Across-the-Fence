/*
    File: fn_radioJamming_preInit.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Server preInit for the radio jamming system. Initializes the global
        jammer array and subscribes to mission end for cleanup.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
*/

if (!isServer) exitWith {};

vgm_s_radioJammer_sites = [];
publicVariable "vgm_s_radioJammer_sites";

// Clean up on mission end
["vgm_mission_ended", {
    vgm_s_radioJammer_sites = [];
    publicVariable "vgm_s_radioJammer_sites";
}] call para_g_fnc_event_subscribe;
