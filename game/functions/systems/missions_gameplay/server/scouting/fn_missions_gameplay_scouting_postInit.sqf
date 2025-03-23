/*
    File: fn_mission_gameplay_scouting_postInit.sqf
    Author: Savage Game Design
    Date: 2024-08-09
    Last Update: 2025-02-14
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

["vgm_mission_ended", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_scouting_onMissionEnded;
}] call para_g_fnc_event_subscribeServer;

vgm_scouting_spottableBlacklist = [
    "Land_vn_o_wallfoliage_01",
    "Land_vn_o_snipertree_01",
    "Land_vn_o_shelter_01",
    "Land_vn_o_shelter_03",
    "Land_vn_o_shelter_04",
    "Land_vn_o_shelter_06",
    "Land_vn_vegetation_base"
];

["vgm_sites_siteSpawned", {
    (_this#0) params ["_site"];

    {
        private _object = _x;
        if (vgm_scouting_spottableBlacklist findIf {_object isKindOf _x} > -1) then {continue};
        [_object, _site] call vgm_s_fnc_missions_gameplay_scouting_setSpottable;
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

    ["vgm_scouting_setSitePhoto", {
        (_this#0) params ["_siteId", "_photoData", "_player"];
        [_siteId, _photoData, _player] call vgm_s_fnc_missions_gameplay_scouting_handleSetSitePhoto;
    }] call para_g_fnc_event_subscribe;
};
