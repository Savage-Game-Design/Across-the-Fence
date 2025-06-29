/*
    File: fn_itemType.sqf
    Author: Savage Game Design
    Date: 2024-12-06
    Last Update: 2025-06-29
    Public: Yes

    Description:
        Returns item category and type. See https://community.bistudio.com/wiki/BIS_fnc_itemType

    Parameter(s):
        _class - Item class to check

    Returns:
        Category, Type [ARRAY]

    Example(s):
        "vn_helper_item_firstaidkit" call vgm_g_fnc_itemType
 */

params [
    ["_class", "", [""]]
];

if (isNil "vgm_core_itemTypeCache") then {
    vgm_core_itemTypeCache = createHashMapFromArray [
        // Special handling for dummy FAKs and Medikits
        ["vn_helper_item_firstaidkit", ["Item", "FirstAidKit"]],
        ["vn_helper_item_medikit", ["Item", "Medikit"]]
    ];
};


vgm_core_itemTypeCache getOrDefaultCall [_class, {
    _class call BIS_fnc_itemType
}, true] // return
