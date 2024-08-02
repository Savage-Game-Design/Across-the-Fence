#include "../../sites.inc"

/*
    File: fn_sites_types_truckPark.sqf
    Author: Savage Game Design
    Date: 2024-06-27
    Last Update: 2024-07-04
    Public: Yes

    Description:
        Creates a new "Truck park" site type

        Registered in cfg_site_types.hpp

    Parameter(s):
        N/A

    Returns:
        New site type, see vgm_s_fnc_sites_getTemplate for example [HashMap]

    Example(s):
        # See cfg_site_types.hpp
        # Alternatively:
        [
            []  call vgm_s_fnc_sites_type_truckPark;
        ] call vgm_s_fnc_site_addSiteType;
 */

private _site = [] call vgm_s_fnc_sites_getTemplate;

_site set ["name", "STR_VGM_SITES_TRUCK_PARK"];
_site set ["size", SITE_FOOTPRINT_LARGE];
_site set ["locRequirements", ["covered", "near_road"]];
_site set ["spawnFunction", {
    params ["_pos2D"];

    [[ ]]
}];

_site
