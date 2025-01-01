/*
    File: fn_mission_gameplay_scouting_postInit.sqf
    Author: Savage Game Design
    Date: 2024-08-09
    Last Update: 2025-01-01
    Public: No

    Description:
        client Post init for mission gameplay scouting system.
 */

if (!hasInterface) exitWith {};

vgm_scouting_locations = createHashMap;

vgm_scouting_siteTypes = "getNumber (_x >> 'disabled') == 0" configClasses (missionConfigFile >> "vgm_site_types") apply {
    [
        localize getText (_x >> "displayNameKey"), // name first, for sorting
        configName _x,
        getText (_x >> "locationClass")
    ]
};
vgm_scouting_siteTypes sort true;

[true, "vn_photoCamera_pictureTaken", {
    call vgm_c_fnc_missions_gameplay_scouting_onPhoto;
}] call BIS_fnc_addScriptedEventHandler;

["vgm_scouting_spottedSiteClient", {
    (_this#0) params ["_siteId", "_spotter"];
}] call para_g_fnc_event_subscribeServer;

["vgm_scouting_addedSiteClient", {
    (_this#0) params ["_siteId", "_player"];

    ["VGM_SiteAdded", [name _player, parseNumber _siteId + 1]] call BIS_fnc_showNotification;

}] call para_g_fnc_event_subscribeServer;

["vgm_scouting_markedSiteClient", {
    (_this#0) params ["_siteId", "_player"];

    ["VGM_SitePositionChanged", [name _player, parseNumber _siteId + 1]] call BIS_fnc_showNotification;
    [_siteId] call vgm_c_fnc_missions_gameplay_scouting_createUpdateLocation;

}] call para_g_fnc_event_subscribeServer;

["vgm_scouting_siteTypeChangedClient", {
    (_this#0) params ["_siteId", "_player"];

    ["VGM_SiteTypeChanged", [name _player, parseNumber _siteId + 1]] call BIS_fnc_showNotification;
    [_siteId] call vgm_c_fnc_missions_gameplay_scouting_createUpdateLocation;

}] call para_g_fnc_event_subscribeServer;

["vgm_mission_deploy_local", {
    {deleteLocation (vgm_scouting_locations deleteAt _x)} forEach vgm_scouting_locations;
}] call para_g_fnc_event_subscribeLocal;
