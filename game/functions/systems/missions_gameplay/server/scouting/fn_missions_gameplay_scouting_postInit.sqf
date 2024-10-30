/*
    File: fn_mission_gameplay_scouting_postInit.sqf
    Author: Savage Game Design
    Date: 2024-08-09
    Last Update: 2024-10-30
    Public: No

    Description:
        Server Post init for mission gameplay scouting system.
 */

if (!isServer) exitWith {};

["vgm_mission_available", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_scouting_registerMission;
}] call para_g_fnc_event_subscribeServer;

["vgm_mission_started", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_scouting_onMissionStarted;
}] call para_g_fnc_event_subscribeServer;

["vgm_sites_siteSpawned", {
    (_this#0) params ["_site"];

    {
        if (_x isKindOf "Land_vn_vegetation_base") then {continue};
        [_x, _site] call vgm_s_fnc_missions_gameplay_scouting_setSpottable;
    } forEach (_site get "objects");
}] call para_g_fnc_event_subscribeServer;

// user input related
call {
    ["vgm_scouting_addSite", {
        (_this#0) params ["_player"];
        [_player] call vgm_s_fnc_missions_gameplay_scouting_handleAdded;
    }] call para_g_fnc_event_subscribe;

    ["vgm_scouting_markSite", {
        (_this#0) params ["_siteId", "_markedPos", "_player"];
        [_siteId, _markedPos, _player] call vgm_s_fnc_missions_gameplay_scouting_handleMarked;
    }] call para_g_fnc_event_subscribe;

    ["vgm_scouting_setSiteType", {
        (_this#0) params ["_siteId", "_siteType", "_player"];
        [_siteId, _siteType, _player] call vgm_s_fnc_missions_gameplay_scouting_handleSetSiteType;
    }] call para_g_fnc_event_subscribe;

    ["vgm_scouting_setSiteTypeFromObject", {
        (_this#0) params ["_siteId", "_siteObject", "_player"];
        private _site = _siteObject getVariable "vgm_missions_gameplay_scouting_site";
        format ["Set site type from object: %1", _siteObject] call vgm_g_fnc_logInfo;

        [_siteId, _site get "class", _player] call vgm_s_fnc_missions_gameplay_scouting_handleSetSiteType;
    }] call para_g_fnc_event_subscribe;
};
