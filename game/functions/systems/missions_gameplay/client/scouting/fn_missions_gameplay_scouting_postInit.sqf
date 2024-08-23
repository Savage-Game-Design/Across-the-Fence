/*
    File: fn_mission_gameplay_scouting_postInit.sqf
    Author: Savage Game Design
    Date: 2024-08-09
    Last Update: 2024-08-23
    Public: No

    Description:
        client Post init for mission gameplay scouting system.
 */

if (!hasInterface) exitWith {};

[true, "vn_photoCamera_pictureTaken", {
    params ["_cursorTarget"];
    if !(_cursorTarget getVariable ["vgm_missions_gameplay_scouting_spottable", false]) exitWith {};

    ["vgm_scouting_spottedTarget", [player, _cursorTarget]] call para_g_fnc_event_triggerServer;

}] call BIS_fnc_addScriptedEventHandler;

["vgm_scouting_spottedSiteClient", {
    (_this#0) params ["_siteId", "_spotter"];
    ["VGM_SiteSpotted", [
        format [localize "STR_VGM_MISSIONS_SCOUTING_NOTIFICATION_SITE_SPOTTED_DESCRIPTION", name _spotter]
    ]] call BIS_fnc_showNotification;
}] call para_g_fnc_event_subscribeServer;

["vgm_scouting_markedSiteClient", {
    (_this#0) params ["_siteId", "_spotter"];
    ["VGM_SiteMarked", [
        format [localize "STR_VGM_MISSIONS_SCOUTING_NOTIFICATION_SITE_MARKED_DESCRIPTION", name _spotter]
    ]] call BIS_fnc_showNotification;
}] call para_g_fnc_event_subscribeServer;

["vgm_scouting_missedSiteClient", {
    (_this#0) params ["_siteId", "_spotter"];
    ["VGM_SiteMissed"] call BIS_fnc_showNotification;
}] call para_g_fnc_event_subscribeServer;
