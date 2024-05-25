/*
    File: fn_missions_postInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2023-11-23
    Public: No

    Description:
        Initialises the mission system on the client, setting up necessary state.
 */

if (!hasInterface) exitWith {};

[{
    ["vgm_missions_clientReady", []] call para_g_fnc_event_triggerServer;
}] call para_g_fnc_netmap_onReady;

// To remove later, this is just for debugging right now.
["missions system postinit", []] call para_g_fnc_event_triggerLocal;
