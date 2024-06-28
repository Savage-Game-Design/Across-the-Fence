/*
    File: fn_sites_types_shelter.sqf
    Author: Savage Game Design
    Date: 2024-06-27
    Last Update: 2024-06-27
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

private _shelter = [] call vgm_s_fnc_sites_getTemplate;

_shelter set ["name", "STR_VGM_SITES_SLOPED_SHELTER"];
_shelter set ["spawnFunction", {
    params ["_pos2D"];

    private _shelter = createVehicle ["Land_vn_o_shelter_03", [_pos2D # 0, _pos2D # 1, 0], [], 0, "NONE"];

    [[ _shelter ]]
}];

_shelter
