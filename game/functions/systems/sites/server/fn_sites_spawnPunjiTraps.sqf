#include "../sites.inc"

/*
    File: fn_sites_spawnPunjiTraps.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Spawns punji traps in a perimeter ring around a site when it is created.
        When a trap is triggered near a player, the mission director is alerted
        with the same weight as an unsuppressed gunshot.
        Mines are pushed into the site's objects array for automatic cleanup.

    Parameter(s):
        _site - Site hashmap from vgm_s_fnc_sites_spawn [HASHMAP]

    Returns:
        Nothing

    Example(s):
        ["vgm_sites_siteSpawned", { (_this#0) call vgm_s_fnc_sites_spawnPunjiTraps }] call para_g_fnc_event_subscribeServer
 */

if (!isServer) exitWith {};

params ["_site"];

// Skip virtual sites (BDA, convoys) — they don't have punji defenses
if (_site getOrDefault ["virtual", false]) exitWith {};

private _sitePos = _site get "pos";
private _siteType = _site getOrDefault ["type", createHashMap];
private _siteSize = _siteType getOrDefault ["size", SITE_FOOTPRINT_MEDIUM];
private _objects = _site get "objects";

// Punji mine classes
private _punjiClasses = ["vn_mine_punji_01", "vn_mine_punji_02", "vn_mine_punji_03", "vn_mine_punji_05"];

// Ring radii scaled by site size
private _ringRadii = switch (_siteSize) do {
    case SITE_FOOTPRINT_SMALL:  { [10, 25] };
    case SITE_FOOTPRINT_MEDIUM: { [15, 35] };
    default                     { [20, 40] };
};
_ringRadii params ["_innerRadius", "_outerRadius"];

// --- Perimeter traps (3-5) ---
private _perimeterCount = 3 + floor random 3;

for "_i" from 1 to _perimeterCount do {
    private _pos = [_sitePos, _outerRadius, _innerRadius] call vgm_g_fnc_randomPosInRing;
    private _mine = createMine [selectRandom _punjiClasses, _pos, [], 0];
    east revealMine _mine;
    civilian revealMine _mine;
    _mine setVariable ["vgm_punjiPos", getPos _mine];
    _mine addEventHandler ["Deleted", {
        params ["_entity"];
        private _minePos = _entity getVariable ["vgm_punjiPos", [0,0,0]];
        if (_minePos isEqualTo [0,0,0]) exitWith {};
        // Only alert if a player is near the mine (i.e. it was triggered, not cleaned up)
        private _nearPlayers = _minePos nearEntities ["CAManBase", 5] select { isPlayer _x };
        if (_nearPlayers isEqualTo []) exitWith {};
        {
            if ((_x get "public" get "status") == "IN PROGRESS") then {
                private _zone = _x get "public" get "targetZone";
                private _marker = _zone call vgm_g_fnc_missions_getZoneMarker;
                if (_minePos inArea _marker) exitWith {
                    private _director = _x get "director";
                    [_director, vgm_s_director_noiseEventAlertness get "unsuppressedShots"] call vgm_s_fnc_director_addAlertness;
                    format ["Punji trap triggered near player at %1 — alerting mission director", _minePos] call vgm_g_fnc_logInfo;
                };
            };
        } forEach ([] call vgm_s_fnc_missions_getAllMissions);
    }];
    _objects pushBack _mine;
};

format ["Punji traps: spawned %1 perimeter traps around site at %2 (size: %3)", _perimeterCount, _sitePos, _siteSize] call vgm_g_fnc_logInfo;
