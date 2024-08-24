/*
    File: fn_missions_zones_spawnRandomSites.sqf
    Author: Savage Game Design
    Date: 2024-08-22
    Last Update: 2024-08-29
    Public: Yes

    Description:
        Spawns random sites in a zone, weighted by the zone's available slots.

    Parameter(s):
        _targetZone - Zone to spawn sites in [STRING]
        _quantity - Number of sites to spawn [NUMBER]

    Returns:
        All spawned sites [ARRAY]

    Example(s):
        ["oscar8", 10] call vgm_s_fnc_missions_zones_spawnRandomSites;
 */

params ["_targetZone", "_quantity"];

private _zoneSites = vgm_missions_zones_spawnedSites getOrDefault [_targetZone, [], true];

private _locations = [_targetZone] call vgm_s_fnc_loc_getTargetBoxLocations;

private _siteTypes = [] call vgm_s_fnc_sites_getAllSiteTypes;
private _siteTypeIds = keys _siteTypes;
private _siteWeights = _siteTypeIds apply {count (_locations getOrDefault [_x, []])};

private _occupiedLocations = createHashMap;
private _createdSites = [];

for "_i" from 1 to _quantity do {
    private _chosenSiteId = "";
    private _siteLocations = [];
    private _siteSelectionAttempts = 0;
    while { count _siteLocations isEqualTo 0 && _siteSelectionAttempts < 3 } do {
        _siteSelectionAttempts = _siteSelectionAttempts + 1;
        _chosenSiteId = _siteTypeIds selectRandomWeighted _siteWeights;
        _siteLocations = _locations getOrDefault [_chosenSiteId, []];
    };

    // If we didn't find a valid site, just continue with the next spawning attempt.
    if (_siteLocations isEqualTo []) then {
        continue;
    };

    private _chosenLocation = selectRandom _siteLocations;
    private _locationAttempts = 0;
    while { _chosenLocation in _occupiedLocations && _locationAttempts < 3 } do {
        _locationAttempts = _locationAttempts + 1;
        _chosenLocation = selectRandom _siteLocations;
    };

    if (_chosenLocation in _occupiedLocations) then {
        continue;
    };

    _occupiedLocations set [_chosenLocation, true];

    private _createdSite = [_chosenSiteId, _chosenLocation] call vgm_s_fnc_sites_spawn;
    // Add to _zoneSites as sites are spawned. That way if a later spawn errors, earlier sites can be cleaned up.
    _zoneSites pushBack _createdSite;
    _createdSites pushBack _createdSite;
};

_createdSites
