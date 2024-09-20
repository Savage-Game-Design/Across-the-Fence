#include "../../sites.inc"

/*
    File: fn_sites_types_bulldozer.sqf
    Author: Savage Game Design
    Date: 2024-06-27
    Last Update: 2024-08-15
    Public: Yes

    Description:
        Creates a new "Bulldozer" site type

        Registered in cfg_site_types.hpp

    Parameter(s):
        N/A

    Returns:
        New site type, see vgm_s_fnc_sites_getTemplate for example [HashMap]

    Example(s):
        # See cfg_site_types.hpp
        # Alternatively:
        [
            []  call vgm_s_fnc_sites_type_bulldozer;
        ] call vgm_s_fnc_site_addSiteType;
 */

private _site = [] call vgm_s_fnc_sites_getTemplate;

_site set ["name", "STR_VGM_SITES_BULLDOZER"];
_site set ["size", SITE_FOOTPRINT_SMALL];
_site set ["locRequirements", ["near_road"]];
_site set ["spawnFunction", {
    params ["_pos2D"];

    private _composition = [["Land_vn_bulldozer_01_abandoned_f",[0,0],1.55249,1.55249,[-0.0345758,-0.999402,0],[0,0,1],1,0,"",true,true,false]];
    private _objects = [_pos2D + [0], 0, _composition] call vgm_g_fnc_objGrabber_map;

    createHashMapFromArray [
        ["objects", _objects]
    ]
}];

_site
