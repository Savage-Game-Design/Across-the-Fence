#include "../../sites.inc"

/*
    File: fn_sites_types_truckPark.sqf
    Author: Savage Game Design
    Date: 2024-06-27
    Last Update: 2024-08-24
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

    private _composition = [["vn_o_wheeled_z157_fuel_nva65",[0,0],1.94047,1.94047,[0.298872,0.954293,0],[0,0,1],1,0,"",true,true,true]];
    private _objects = [_pos2D + [0], 0, _composition] call vgm_g_fnc_objGrabber_map;

    createHashMapFromArray [
        ["objects", _objects]
    ]
}];

_site
