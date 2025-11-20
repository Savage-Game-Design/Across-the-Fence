/*
    File: fn_missions_zones_clearSites.sqf
    Author: Savage Game Design
    Date: 2024-08-22
    Last Update: 2025-11-20
    Public: Yes

    Description:
        Clears all sites from a zone.

    Parameter(s):
        _targetZone - Zone to spawn sites in [STRING]

    Returns:
        None

    Example(s):
        ["oscar8"] call vgm_s_fnc_missions_zones_clearSites
 */

params ["_targetZone"];

private _zoneSites = vgm_missions_zones_spawnedSites getOrDefault [_targetZone, [], true];

// Delete everything from 0 to the current max index.
// Go backwards, because:
// - No newly added sites are deleted (i.e - no race condition)
// - Better performance using deleteAt on the array.
private _deleteIndex = count _zoneSites;

while { _deleteIndex > 0 } do {
    // Decrement first, in case there's an error later.
    _deleteIndex = _deleteIndex - 1;
    private _site = _zoneSites # _deleteIndex;
    [_site] call vgm_s_fnc_sites_delete;

    _zoneSites deleteAt _deleteIndex;
};

// clear sites on clients
private _zoneInfo = (["vgm_missions_zones_zoneInfoById"] call para_g_fnc_netmap_get) get _targetZone;
if (!isNil "_zoneInfo") then {
    [_zoneInfo, "sites", []] call para_s_fnc_netmap_set;
};
