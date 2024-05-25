/*
    File: sites_postInit.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-05-25
    Public: Yes

    Description:
        PostInit for sites.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
 */


private _shelter = [] call vgm_s_fnc_sites_getTemplate;

_shelter set ["id", "vgm_sloped_shelter"];
_shelter set ["name", "STR_VGM_SITES_SLOPED_SHELTER"];
_shelter set ["spawnFunction", {
    params ["_pos2D"];

    private _shelter = createVehicle ["Land_vn_o_shelter_03", [_pos2D # 0, _pos2D # 1, 0], [], 0, "NONE"];

    [[ _shelter ]]
}];

[_shelter] call vgm_s_fnc_sites_addSiteType;


private _campFire = [] call vgm_s_fnc_sites_getTemplate;

_campFire set ["id", "vgm_campfire"];
_campFire set ["name", "STR_VGM_SITES_CAMPFIRE"];
_campFire set ["spawnFunction", {
    params ["_pos2D"];

    private _campFire = createVehicle ["Land_Campfire_F", [_pos2D # 0, _pos2D # 1, 0], [], 0, "NONE"];

    [[ _campFire ]]
}];

_campFire get "fortifications" pushBack createHashMapFromArray [
    ["typeId", "vgm_sloped_shelter"],
    ["radius", 20],
    ["weight", 1]
];

[_campFire] call vgm_s_fnc_sites_addSiteType;
