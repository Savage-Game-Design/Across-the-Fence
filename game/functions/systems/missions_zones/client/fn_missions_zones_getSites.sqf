/*
    File: fn_missions_zones_getSites.sqf
    Author: Savage Game Design
    Date: 2025-01-23
    Last Update: 2025-01-23
    Public: No

    Description:
        Returns all sites in a zone.

    Parameter(s):
        _zoneName - Id of the zone [STRING]

    Returns:
        Sites in a zone [ARRAY]

    Example(s):
        "1" call vgm_c_fnc_missions_zones_getSites
 */

params ["_zoneName"];

private _sitesNetmap = "vgm_missions_zones_spawnedSitesPublic" call para_g_fnc_netmap_get;

_sitesNetmap getOrDefault [_zoneName, []] // return
