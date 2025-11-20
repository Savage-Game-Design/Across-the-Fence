/*
    File: fn_missions_zones_getSites.sqf
    Author: Savage Game Design
    Date: 2025-01-23
    Last Update: 2025-11-20
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

(["vgm_missions_zones_zoneInfoById"] call para_g_fnc_netmap_get) get _zoneName getOrDefault ["sites", []]
