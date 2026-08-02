/*
    File: fn_missions_preInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2026-01-20
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

    // Fire one event per existing mission so handlers receive [_missionId] like
    // they do when a mission is first created via triggerGlobal.
    {
        [
            "vgm_mission_available",
            [_x],
            [_originMachineId]
        ] call para_g_fnc_event_triggerTargets;
    } forEach (keys _missions);
}] call para_g_fnc_event_subscribe;

addMissionEventHandler ["PlayerDisconnected", {
    params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];

    // Check if the player was on an active mission before leaving Ã¢â‚¬â€ apply abandon penalty
    private _mission = [_idstr] call vgm_s_fnc_missions_getAssignedMission;
    if (!isNil "_mission") then {
        private _missionStatus = (_mission get "public") getOrDefault ["status", ""];
        if (_missionStatus == "IN PROGRESS") then {
            // Find the player object by UID before it becomes invalid
            private _player = objNull;
            {
                if (getPlayerUID _x == _uid) exitWith {_player = _x};
            } forEach allPlayers;
            if (!isNull _player) then {
                [_player, -50] call vgm_s_fnc_leveling_addExperience;
                (format ["XP PENALTY: Mission abandon -50 XP to %1 (%2)", _name, _uid]) call vgm_g_fnc_logInfo;
            };
        };
    };

    [_idstr] call vgm_s_fnc_missions_leaveMission;
}];

addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer", "_instigator"];
    if (!isNull _instigator) then {_killer = _instigator};
    if (!isPlayer _killer) exitWith {};
    if !(_unit isKindOf "CAManBase") exitWith {};
    if (side group _unit != east) exitWith {};
    private _mission = [getPlayerID _killer] call vgm_s_fnc_missions_getAssignedMission;
    if (isNil "_mission") exitWith {};
    _mission set ["vgm_s_missionKills", (_mission getOrDefault ["vgm_s_missionKills", 0]) + 1];
}];
