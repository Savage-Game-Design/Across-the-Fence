/*
    File: fn_missions_zones_getSites.sqf
    Author:
    Date: 2024-08-24
    Last Update: 2024-08-24
    Public: No

    Description:
        Returns an array of sites currently spawned in the named target box.

    Parameter(s):
        _targetZone - ID of the target zone [STRING]

    Returns:
        Array of sites [ARRAY]

    Example(s):
        ["oscar8"] call vgm_s_fnc_missions_zones_getSites;
 */

params ["_targetZone"];

vgm_missions_zones_spawnedSites getOrDefault [_targetZone, []];
