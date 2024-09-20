#include "../../sites.inc"

/*
    File: fn_sites_types_ammoCache.sqf
    Author: Savage Game Design
    Date: 2024-06-27
    Last Update: 2024-08-15
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

    private _composition = [["Land_vn_pavn_weapons_stack2",[-0.789063,-0.753174],-0.00256729,-0.00572395,[0.951401,0.307952,0.00123082],[0,-0.00399675,0.999992],1,0,"",true,true,false],["Land_vn_pavn_weapons_stack1",[-0.271729,0.984131],-0.00221062,-0.00329781,[-0.0460609,0.998939,0.000184095],[0.00399675,0,0.999992],1,0,"",true,true,false],["Land_vn_pavn_weapons_stack3",[1.06006,-0.231689],-0.00117683,0.0030632,[0,1,0],[0.00399675,0,0.999992],1,0,"",true,true,false]];
    private _objects = [_pos2D + [0], 0, _composition] call vgm_g_fnc_objGrabber_map;

    createHashMapFromArray [
        ["objects", _objects]
    ]
}];

_site
