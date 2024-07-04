#include "../../sites.inc"

/*
    File: fn_sites_types_supplyDump.sqf
    Author: Savage Game Design
    Date: 2024-06-27
    Last Update: 2024-07-04
    Public: Yes

    Description:
        Creates a new "Supply dump" site type

        Registered in cfg_site_types.hpp

    Parameter(s):
        N/A

    Returns:
        New site type, see vgm_s_fnc_sites_getTemplate for example [HashMap]

    Example(s):
        # See cfg_site_types.hpp
        # Alternatively:
        [
            []  call vgm_s_fnc_sites_type_supplyDump;
        ] call vgm_s_fnc_site_addSiteType;
 */

private _site = [] call vgm_s_fnc_sites_getTemplate;

_site set ["name", "STR_VGM_SITES_SUPPLY_DUMP"];
_site set ["size", SITE_FOOTPRINT_MEDIUM];
_site set ["locRequirements", ["covered"]];
_site set ["spawnFunction", {
    params ["_pos2D"];

    [[ ]]
}];

_site
