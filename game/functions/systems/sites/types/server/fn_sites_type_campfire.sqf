#include "../../sites.inc"

/*
    File: fn_sites_types_shelter.sqf
    Author: Savage Game Design
    Date: 2024-06-27
    Last Update: 2024-09-21
    Public: Yes

    Description:
        Creates a new "Shelter" site type

        Registered in cfg_site_types.hpp

    Parameter(s):
        N/A

    Returns:
        New site type, see vgm_s_fnc_sites_getTemplate for example [HashMap]

    Example(s):
        # See cfg_site_types.hpp
        # Alternatively:
        [
            []  call vgm_s_fnc_sites_type_shelter;
        ] call vgm_s_fnc_site_addSiteType;
 */

private _campFire = [] call vgm_s_fnc_sites_getTemplate;

_campFire set ["size", SITE_FOOTPRINT_SMALL];
_campFire set ["spawnFunction", {
    params ["_pos2D"];

    private _campFire = createVehicle ["Land_Campfire_F", [_pos2D # 0, _pos2D # 1, 0], [], 0, "NONE"];

    createHashMapFromArray [
        ["objects", [ _campFire ]]
    ]
}];

_campFire get "fortifications" pushBack createHashMapFromArray [
    ["typeId", "vgm_shelter"],
    ["radius", 20],
    ["weight", 1]
];

_campfire
