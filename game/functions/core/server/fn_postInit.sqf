/*
    File: fn_postInit.sqf
    Author: Savage Game Design
    Date: 2023-09-19
    Last Update: 2023-09-19
    Public: No

    Description:
        Core component server postInit script.
 */

if (!isServer) exitWith {};

private _lobbyGroup = missionNamespace getVariable ["vgm_core_lobbyGroup", grpNull];
if (isNull _lobbyGroup) exitWith {
    "'vgm_core_lobbyGroup' not present in mission.sqm, mission will NOT function properly" call vgm_g_fnc_logError;
};

private _lobbyOfficer = missionNamespace getVariable ["vgm_core_lobbyOfficer", objNull];
if (isNull _lobbyOfficer || {!(_lobbyOfficer in units _lobbyGroup)}) then {
    "'vgm_core_lobbyOfficer' not in 'vgm_core_lobbyGroup', adding Logic to prevent group deletion" call vgm_g_fnc_logWarning;

    private _logic = _lobbyGroup createUnit ["Logic", [0,0,0], [], 0, "CAN_COLLIDE"];
    _logic enableSimulation false;
    _logic disableAI "ALL";
    vgm_core_lobbyGroup selectLeader _logic;
};
