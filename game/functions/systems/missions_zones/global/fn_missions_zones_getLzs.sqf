/*
    File: fn_missions_zones_getLzs.sqf
    Author: Savage Game Design
    Date: 2025-11-20
    Last Update: 2025-11-20
    Public: Yes

    Description:
        Gets a list of active LZ positions in the target zone

    Parameter(s):
        _zoneName - Id of the zone [STRING]

    Returns:
        Active LZ position2Ds [ARRAY]

    Example(s):
        ["1"] call vgm_g_fnc_missions_zones_getLzs;
 */

params ["_zoneName"];

(["vgm_missions_zones_zoneInfoById"] call para_g_fnc_netmap_get) get _zoneName getOrDefault ["lzs", []]
