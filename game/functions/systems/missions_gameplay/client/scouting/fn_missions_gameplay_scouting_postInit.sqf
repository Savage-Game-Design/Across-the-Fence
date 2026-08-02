/*
    File: fn_mission_gameplay_scouting_postInit.sqf
    Author: Savage Game Design
    Date: 2024-08-09
    Last Update: 2025-02-14
    Public: No

    Description:
        client Post init for mission gameplay scouting system.
 */

if (!hasInterface) exitWith {};

vgm_scouting_locations = createHashMap;
vgm_scouting_objectPointsCache = createHashMap;
vgm_c_scouting_spottedSites = createHashMap;
vgm_c_scouting_spotProgress = createHashMap;

vgm_scouting_siteTypes = "getNumber (_x >> 'disabled') == 0" configClasses (missionConfigFile >> "vgm_site_types") apply {
    [
        localize getText (_x >> "displayNameKey"), // name first, for sorting
        configName _x,
        getText (_x >> "locationClass")
    ]
};
// Add virtual site types (disabled in config, so not loaded by server)
vgm_scouting_siteTypes pushBack [localize "STR_VGM_SITES_CONVOY", "vgm_convoy", "o_motor_inf"];
vgm_scouting_siteTypes pushBack [localize "STR_VGM_SITES_BDA", "vgm_bda", "o_unknown"];
vgm_scouting_siteTypes sort true;

[true, "vn_photoCamera_pictureTaken", {
    call vgm_c_fnc_missions_gameplay_scouting_onPhoto;
}] call BIS_fnc_addScriptedEventHandler;

["vgm_scouting_spottedSiteClient", {
    (_this#0) params ["_siteId", "_spotter"];

    hint parseText format [
        "<t size='1.2' color='#82E0AA'>Site Spotted</t><br/><t size='0.9'>%1 spotted a site</t>",
        name _spotter
    ];

    [_siteId] call vgm_c_fnc_missions_gameplay_scouting_createUpdateLocation;

    private _mapDisplay = findDisplay 12;
    if (!isNull _mapDisplay) then {
        ["refreshUI", _mapDisplay] call vgm_c_fnc_displayNotepad;
    };
}] call para_g_fnc_event_subscribeServer;

["vgm_scouting_addedSiteClient", {
    (_this#0) params ["_siteId", "_player"];

    ["VGM_SiteAdded", [name _player, parseNumber _siteId + 1]] call BIS_fnc_showNotification;

    // If a vehicle photo is pending, enter photo mode now that the guessed entry exists
    if (!isNil "vgm_c_scouting_pendingVehiclePhoto") then {
        private _photoData = vgm_c_scouting_pendingVehiclePhoto;
        vgm_c_scouting_pendingVehiclePhoto = nil;
        private _mapDisplay = findDisplay 12;

        _mapDisplay setVariable ["vgm_site_photoData", _photoData];
        ["refreshUI", _mapDisplay] call vgm_c_fnc_displayNotepad;

        [] spawn {
            private _d = findDisplay 12;
            sleep 0.3;
            openMap [true, false];
            waitUntil {!visibleMap};

            if (!isNil {_d getVariable "vgm_site_photoData"}) then {
                playSoundUI ["hint"];
            };
            _d setVariable ["vgm_site_photoData", nil];
            ["refreshUI", _d] call vgm_c_fnc_displayNotepad;
        };
    };
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

["vgm_scouting_sitePhotoChangedClient", {
    (_this#0) params ["_siteId", "_player"];

    ["VGM_SitePhotoChanged", [name _player, parseNumber _siteId + 1]] call BIS_fnc_showNotification;
    [_siteId] call vgm_c_fnc_missions_gameplay_scouting_createUpdateLocation;

}] call para_g_fnc_event_subscribeServer;

["vgm_mission_deploy_local", {
    {deleteLocation (vgm_scouting_locations deleteAt _x)} forEach vgm_scouting_locations;
    vgm_c_scouting_spottedSites = createHashMap;
    vgm_c_scouting_spotProgress = createHashMap;
}] call para_g_fnc_event_subscribeLocal;

// --- Auto-spot detection loop ---
// Periodically checks if sites are in the player's field of view with clear LOS.
// After 4 seconds of sustained observation, fires a spot event to the server which
// auto-adds a guessed entry with approximate position and identified type.
[] spawn {
    waitUntil {sleep 1; !isNull player && {alive player}};

    while {true} do {
        sleep 2;

        if (!alive player) then {continue};

        private _mission = call vgm_c_fnc_missions_getCurrentMission;
        if (isNil "_mission") then {
            vgm_c_scouting_spotProgress = createHashMap;
            continue;
        };

        private _targetZone = _mission get "targetZone";
        if (isNil "_targetZone") then {continue};

        private _sites = _targetZone call vgm_c_fnc_missions_zones_getSites;
        if (_sites isEqualTo []) then {continue};

        private _eyePos = eyePos player;
        private _zoom = (getResolution # 6) / getObjectFOV player;
        // Binoculars / optics extend range from 200m to 500m
        private _spotRange = [200, 500] select (_zoom > 1.5);

        {
            private _siteId = _x get "id";
            if (vgm_c_scouting_spottedSites getOrDefault [_siteId, false]) then {continue};

            // Build check position: 2m above site center
            private _checkPos = +(_x get "pos");
            _checkPos set [2, (getTerrainHeightASL _checkPos) + 2];

            // Perceived distance check (zoom reduces perceived distance)
            if (((getPos player) distance2D _checkPos) / _zoom > _spotRange) then {
                vgm_c_scouting_spotProgress deleteAt _siteId;
                continue;
            };

            // Screen check — must be actively looking toward the site
            private _screenPos = worldToScreen (ASLToAGL _checkPos);
            if (_screenPos isEqualTo []) then {
                vgm_c_scouting_spotProgress deleteAt _siteId;
                continue;
            };
            _screenPos params ["_sX", "_sY"];
            if !(_sX >= 0.15 && {_sX <= 0.85} && {_sY >= 0.15} && {_sY <= 0.85}) then {
                vgm_c_scouting_spotProgress deleteAt _siteId;
                continue;
            };

            // Terrain LOS check
            if (terrainIntersectASL [_eyePos, _checkPos]) then {
                vgm_c_scouting_spotProgress deleteAt _siteId;
                continue;
            };

            // Sustained observation — 2 consecutive checks (4+ seconds)
            private _progress = (vgm_c_scouting_spotProgress getOrDefault [_siteId, 0]) + 1;
            vgm_c_scouting_spotProgress set [_siteId, _progress];

            if (_progress >= 2) then {
                vgm_c_scouting_spottedSites set [_siteId, true];
                vgm_c_scouting_spotProgress deleteAt _siteId;
                ["vgm_scouting_spotSite", [_siteId, _x get "pos", player]] call para_g_fnc_event_triggerServer;
            };
        } forEach _sites;
    };
};
