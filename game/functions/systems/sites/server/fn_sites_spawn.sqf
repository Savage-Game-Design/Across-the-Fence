#include "../sites.inc"

/*
    File: sites_spawn.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-08-24
    Public: Yes

    Description:
        Spawns in a new site of the given type at the given location.

    Parameter(s):
        _typeId - Name of a previously registered site type [STRING]
        _pos2D - Position to spawn the site at. Only the 2D coordinates (x, y) matter [ARRAY]

    Returns:
        Site info - This should be treated as a black box by other systems

    Example(s):
        ["vgm_bunker", [100, 100]] call vgm_s_fnc_sites_spawn;
 */

params ["_typeId", "_pos2D"];

_pos2D = _pos2D select [0, 2];

private _siteType = localNamespace getVariable "vgm_s_sites_siteTypes" get _typeId;

if (isNil "_siteType") exitWith {
    [format ["Failed to spawn unknown site '%1'", _typeId]] call vgm_g_fnc_logError;
};

if (_siteType getOrDefault ["hideNearbyTerrain", false]) then {
    private _radius = (vgm_s_sites_siteRadii getOrDefault [_siteType get "size", SITE_FOOTPRINT_LARGE_RADIUS]);
    private _nearbyTerrain = nearestTerrainObjects [
        _pos2D,
        ["SMALL TREE", "TREE", "HIDE"],
        _radius,
        false,
        true
    ];
    {
        _x hideObjectGlobal true;
    } forEach _nearbyTerrain;
};

private _spawnResult = [_pos2D] call (_siteType get "spawnFunction");

createHashMapFromArray [
    ["type", _siteType],
    ["pos", _pos2D],
    ["objects", _spawnResult get "objects"],
    ["ownedSites", []]
]
