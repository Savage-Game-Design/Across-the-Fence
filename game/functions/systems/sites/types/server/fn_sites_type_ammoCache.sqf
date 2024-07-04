#include "../../sites.inc"

/*
    File: fn_sites_types_ammoCache.sqf
    Author: Savage Game Design
    Date: 2024-06-27
    Last Update: 2024-07-04
    Public: Yes

    Description:
        Creates a new "Ammo cache" site type

        Registered in cfg_site_types.hpp

    Parameter(s):
        N/A

    Returns:
        New site type, see vgm_s_fnc_sites_getTemplate for example [HashMap]

    Example(s):
        # See cfg_site_types.hpp
        # Alternatively:
        [
            []  call vgm_s_fnc_sites_type_ammoCache;
        ] call vgm_s_fnc_site_addSiteType;
 */

private _site = [] call vgm_s_fnc_sites_getTemplate;

_site set ["name", "STR_VGM_SITES_AMMO_CACHE"];
_site set ["size", SITE_FOOTPRINT_SMALL];
_site set ["locRequirements", []];
_site set ["spawnFunction", {
    params ["_pos2D"];

    [[ ]]
}];

_site
