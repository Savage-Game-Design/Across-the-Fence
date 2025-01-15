/*
    File: sites_postInit.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2025-01-15
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

vgm_sites_siteSpawnedHandlers = createHashMap;

["vgm_mission_available", {
    (_this#0) params ["_missionId"];

    // register system specific netmap
    _missionId call vgm_s_fnc_sites_registerMission;

    // add spawned sites to missions
    private _id = ["vgm_sites_siteSpawned", [[_missionId], {
        (_this#0) params ["_site"];
        (_this#1) params ["_missionId"];

        private _mission = [_missionId] call vgm_s_fnc_missions_getById;
        if !([_site, _mission] call vgm_s_fnc_sites_isInMission) exitWith {};

        private _sitesData = [_missionId, "sites"] call vgm_s_fnc_missions_getSystemNetmap;
        [_sitesData get "sites", _site get "pos", _site get "class"] call para_s_fnc_netmap_set;
    }]] call para_g_fnc_event_subscribeServer;

    vgm_sites_siteSpawnedHandlers set [_missionId, _id];

}] call para_g_fnc_event_subscribeServer;

["vgm_mission_ended", {
    (_this#0) params ["_missionId"];

    private _id = vgm_sites_siteSpawnedHandlers deleteAt _missionId;
    [_id] call para_g_fnc_event_unsubscribe;
}] call para_g_fnc_event_subscribeServer;
