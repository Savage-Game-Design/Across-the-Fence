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

    // Auto-spot: client detected a site visually, auto-add guessed entry
    ["vgm_scouting_spotSite", {
        (_this#0) params ["_siteId", "_observedPos", "_player"];

        if (isNull _player) exitWith {};
        private _mission = [getPlayerID _player] call vgm_s_fnc_missions_getAssignedMission;
        if (isNil "_mission") exitWith {};

        private _missionId = _mission get "public" get "id";
        private _data = [_missionId, "scouting"] call vgm_s_fnc_missions_getSystemNetmap;

        // Dedup: check if this real site was already spotted
        private _spottedIds = _data getOrDefault ["spottedSiteIds", []];
        if (_siteId in _spottedIds) exitWith {};

        // Check guessed entry limit
        private _guessedSites = _data get "guessedSites";
        private _currentMax = _data getOrDefault ["guessedSitesMax", 0];
        if (count _guessedSites >= _currentMax) exitWith {};

        // Find real site to get type
        private _targetZone = _mission get "public" get "targetZone";
        private _zoneSites = _targetZone call vgm_s_fnc_missions_zones_getSites;
        private _matchIdx = _zoneSites findIf {_x get "id" == _siteId};
        private _siteType = if (_matchIdx > -1) then {(_zoneSites # _matchIdx) get "class"} else {""};

        // Auto-mark position with 20-40m offset (scoring: "close" to "far" range)
        private _dist = 20 + random 20;
        private _dir = random 360;
        private _markedPos = [
            (_observedPos # 0) + _dist * sin _dir,
            (_observedPos # 1) + _dist * cos _dir
        ];

        // Allocate guessed entry ID
        private _varName = format ["vgm_scouting_siteId_%1", _missionId];
        private _guessId = missionNamespace getVariable [_varName, 0];
        missionNamespace setVariable [_varName, _guessId + 1];
        private _guessIdStr = str _guessId;

        // Create guessed entry with position + type pre-filled
        _guessedSites pushBack [time, _siteType, date, _markedPos, _guessIdStr, createHashMap];
        [_data, "guessedSites", _guessedSites] call para_s_fnc_netmap_set;

        // Track spotted site ID
        _spottedIds pushBack _siteId;
        [_data, "spottedSiteIds", _spottedIds] call para_s_fnc_netmap_set;

        // Notify all mission clients
        private _machineIds = values (_mission get "machineIds");
        ["vgm_scouting_addedSiteClient", [_guessIdStr, _player], _machineIds] call para_g_fnc_event_triggerTargets;
        ["vgm_scouting_spottedSiteClient", [_guessIdStr, _player], _machineIds] call para_g_fnc_event_triggerTargets;

        format ["[Scouting] %1 spotted site '%2' (type: %3) for mission %4", name _player, _siteId, _siteType, _missionId] call vgm_g_fnc_logInfo;
    }] call para_g_fnc_event_subscribe;
};
