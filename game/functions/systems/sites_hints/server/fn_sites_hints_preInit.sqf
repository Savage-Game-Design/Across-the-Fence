/*
    File: fn_sites_hints_preInit.sqf
    Author: Savage Game Design
    Date: 2024-10-25
    Last Update: 2024-11-01
    Public: No

    Description:
        Preinit for the site hints system.
 */

if (!isServer) exitWith {};

vgm_sites_hints_placementConfigs = createHashMap;
vgm_sites_hints_placeHandlers = createHashMap;
vgm_sites_hints_objects = createHashMap;

["vgm_mission_available", {
    (_this#0) params ["_missionId"];

    private _mission = _missionId call vgm_s_fnc_missions_getById;

    private _id = ["vgm_sites_siteSpawned", [[_mission], {
        (_this#0) params ["_site"];
        (_this#1) params ["_mission"];

        [_mission, _site] call vgm_s_fnc_sites_hints_place;
    }]] call para_g_fnc_event_subscribeServer;

    vgm_sites_hints_placeHandlers set [_missionId, _id];
}] call para_g_fnc_event_subscribeServer;

["vgm_mission_ended", {
    (_this#0) params ["_missionId"];

    vgm_sites_hints_objects deleteAt _missionId;

    private _id = vgm_sites_hints_placeHandlers deleteAt _missionId;
    [_id] call para_g_fnc_event_unsubscribe;
}] call para_g_fnc_event_subscribeServer;
