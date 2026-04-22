/*
    File: fn_missions_preInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2026-04-22
    Public: No

    Description:
        Prepares the mission system on the client for initialisation
 */

if (!hasInterface) exitWith {};

vgm_mission_onMission = false;
vgm_mission_givers = [];

["vgm_mission_creationFailed", {
    params ["_args"];
    _args params ["_reason", "_details"];

    if (_reason isEqualTo "ZONE_RESERVATION_FAILED") exitWith {
        hint format [localize "STR_VGM_MISSIONS_CREATION_ZONE_RESERVATION_FAILED", _targetZone];
    };

    hint format [localize "STR_VGM_MISSIONS_CREATION_UNKNOWN_ERROR", _reason];
}] call para_g_fnc_event_subscribeServer;

["vgm_mission_created", {
    (_this # 0) params ["_missionId"];

    createHashMapFromArray [
        ["title", "STR_VGM_MISSIONS_CREATION_CREATED"],
        ["body", format [localize "STR_VGM_MISSIONS_CREATION_CREATED_DETAILS", _missionId]]
    ] call vgm_c_fnc_postNotification;
}] call para_g_fnc_event_subscribeServer;

["vgm_mission_joined", {
    (_this # 0) params ["_playerId", "_missionId"];

    private _publicInfo = [_missionId] call vgm_g_fnc_missions_getPublicInfoById;
    private _leader = leader (_publicInfo get "group");

    if (_leader isEqualTo player) exitWith {};

    createHashMapFromArray [
        ["title", "STR_VGM_MISSIONS_JOINED"],
        ["body", format [localize "STR_VGM_MISSIONS_JOINED_DETAILS", name _leader]]
    ] call vgm_c_fnc_postNotification;
}] call para_g_fnc_event_subscribeServer;
