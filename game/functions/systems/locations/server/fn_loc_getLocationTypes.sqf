/*
    File: fn_loc_getLocationTypes.sqf
    Author: Savage Game Design
    Date: 2024-08-21
    Last Update: 2024-08-21
    Public: Yes

    Description:
        Retrieves all location types, and their required tags

    Parameter(s):
        None

    Returns:
        Map from a location ID to a location type [HASHMAP]

    Example(s):
        [] call vgm_s_fnc_loc_getLocationTypes;
 */

[] call vgm_s_fnc_sites_loadSiteTypesFromConfig;

private _siteTypes = values ([] call vgm_s_fnc_sites_getAllSiteTypes);
private _locationTypes = createHashMapFromArray (
    _siteTypes apply {
        [_x get "id", createHashMapFromArray [
            ["id", _x get "id"],
            ["name", (_x get "name") call para_c_fnc_localize],
            ["requirements", [_x] call vgm_s_fnc_sites_getSiteTypeRequirements]
        ]]
    }
);

// Custom location types. Ideally move this to config, but this works for the moment with only a tiny number of edge cases.
_locationTypes set ["lz", createHashMapFromArray [
    ["id", "lz"],
    ["name", "STR_VGM_LOCATIONS_LZ" call para_c_fnc_localize],
    ["requirements", ["lz"]]
]];

_locationTypes
