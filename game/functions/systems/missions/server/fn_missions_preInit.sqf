/*
    File: fn_missions_preInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2024-12-14
    Public: No

    Description:
        Initialises the mission system, setting up necessary state.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_missions_initSystem
 */

if (!isServer) exitWith {};

// Serverside mission data
localNamespace setVariable ["vgm_missions", createHashMap];
// Mission data available to clients
["vgm_missions_publicMissionInfo"] call para_s_fnc_netmap_createNamedNetmap;
// Missions that players are assigned to.
["vgm_mission_assignments"] call para_s_fnc_netmap_createNamedNetmap;

["vgm_missions_clientReady", {
    private _originMachineId = param [4];
    private _missions = localNamespace getVariable "vgm_missions";

    [
        "vgm_mission_available",
        [keys _missions],
        [_originMachineId]
    ] call para_g_fnc_event_triggerTargets;
}] call para_g_fnc_event_subscribeGlobal;

addMissionEventHandler ["PlayerDisconnected", {
    params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];

    [_idstr] call vgm_s_fnc_missions_leaveMission;
}];
