/*
    File: fn_itemConfig.sqf
    Author: Savage Game Design
    Date: 2025-01-19
    Last Update: 2025-01-19
    Public: Yes

    Description:
        Returns item config.

    Parameter(s):
        _class - Item class to check

    Returns:
        Item config [CONFIG]

    Example(s):
        "vn_helper_item_firstaidkit" call vgm_g_fnc_itemConfig
 */

params [
    ["_class", "", [""]]
];

if (isNil "vgm_core_itemConfigCache") then {
    vgm_core_itemConfigCache = createHashMap;
};

vgm_core_itemConfigCache getOrDefaultCall [_class, {
    private _config = configNull;
    {
        _config = _x >> _class;
        if !(isNull _config) then {break};
    } forEach [
        configFile >> "CfgWeapons",
        configFile >> "CfgMagazines",
        configFile >> "CfgGlasses",
        configFile >> "CfgVehicles"
    ];
    _config // return
}, true];
