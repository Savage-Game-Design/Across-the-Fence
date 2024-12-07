/*
    File: fn_itemType.sqf
    Author: Savage Game Design
    Date: 2024-12-06
    Last Update: 2024-12-06
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
    vgm_core_itemTypeCache = createHashMap;
};

vgm_core_itemTypeCache getOrDefaultCall [_class, {
    // special handling for our dummy non-functional FAK
    if (_class isEqualTo "vn_helper_item_firstaidkit") then {
        ["Item", "FirstAidKit"]
    } else {
        _class call BIS_fnc_itemType
    };
}, true] // return
