/*
    File: fn_sites_hints_getConfig.sqf
    Author: Savage Game Design
    Date: 2024-11-01
    Last Update: 2024-11-02
    Public: No

    Description:
        Fetch hints placement config for specified site class.

    Parameter(s):
        _siteClass - Class name of the site template [STRING]

    Returns:
        Site placement data [HASHMAP]

    Example(s):
        "vgm_ammo_cache" call vgm_s_fnc_sites_hints_getConfig
 */

params ["_siteClass"];

vgm_sites_hints_placementConfigs getOrDefaultCall [_siteClass, {
    private _cfg = missionConfigFile >> "vgm_site_types" >> _siteClass >> "hints";

    createHashMapFromArray [
        ["radius", getNumber (_cfg >> "radius")],
        ["radiusSafezone", getNumber (_cfg >> "radiusSafezone")],
        ["density", getNumber (_cfg >> "density")],
        ["classes", getArray (_cfg >> "classes")]
    ] // return
}, true];
