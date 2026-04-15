/*
    File: fn_missions_zones_spawnRandomSites.sqf
    Author: Savage Game Design
    Date: 2024-08-22
    Last Update: 2026-04-15
    Public: Yes

    Description:
        Spawns random sites in a zone, weighted by the zone's available slots.

    Parameter(s):
        _targetZone - Zone to spawn sites in [STRING]
        _spawnChance - Percentage change that a location has a site [NUMBER]

    Returns:
        All spawned sites [ARRAY]

    Example(s):
        ["oscar8", 0.5] call vgm_s_fnc_missions_zones_spawnRandomSites;
 */

params ["_targetZone", "_spawnChance"];

private _zoneSites = vgm_missions_zones_spawnedSites getOrDefault [_targetZone, [], true];

private _targetBoxLocations = [_targetZone] call vgm_s_fnc_loc_getTargetBoxLocations;

private _positionsToSiteTypes = createHashMap;
private _allSiteTypes = [] call vgm_s_fnc_sites_getAllSiteTypes;

// Invert the map so it's locations to all sites that can be spawn there, so we can work with density.
{
    private _locationType = _x;
    private _positions = _y;

    // Filters out locations that aren't sites, like "lz"
    if !(_locationType in _allSiteTypes) then {
        continue;
    };

    {
        _positionsToSiteTypes getOrDefault [_x, [], true] pushBackUnique _locationType;
    } forEach _positions;
} forEach _targetBoxLocations;

private _occupiedLocations = createHashMap;
private _createdSites = [];

{
    private _position = _x;
    private _possibleSiteTypeIds = _y;

    if (random 1 > _spawnChance) then {
        continue;
    };

    private _chosenSiteTypeId = selectRandom _possibleSiteTypeIds;

    _occupiedLocations set [_position, true];

    private _createdSite = [_chosenSiteTypeId, _position] call vgm_s_fnc_sites_spawn;
    // Add to _zoneSites as sites are spawned. That way if a later spawn errors, earlier sites can be cleaned up.
    _zoneSites pushBack _createdSite;
    _createdSites pushBack _createdSite;
} forEach _positionsToSiteTypes;

// propagate sites to clients
private _zoneInfoNetmap = ["vgm_missions_zones_zoneInfoById"] call para_g_fnc_netmap_get;
[_zoneInfoNetmap get _targetZone, "sites", _createdSites] call para_s_fnc_netmap_set;

_createdSites
