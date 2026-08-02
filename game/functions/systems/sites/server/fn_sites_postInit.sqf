/*
    File: sites_postInit.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2025-01-23
    Public: Yes

    Description:
        PostInit for sites.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
 */

if (!isServer) exitWith {};

// Spawn punji traps around sites when they are created
["vgm_sites_siteSpawned", {
    (_this#0) params ["_site"];
    [_site] call vgm_s_fnc_sites_spawnPunjiTraps;
}] call para_g_fnc_event_subscribeServer;

// Add Killed EHs to high-value targets for combat XP rewards
["vgm_sites_siteSpawned", {
    (_this#0) params ["_site"];
    [_site] call vgm_s_fnc_sites_onObjectDestroyed;
}] call para_g_fnc_event_subscribeServer;
