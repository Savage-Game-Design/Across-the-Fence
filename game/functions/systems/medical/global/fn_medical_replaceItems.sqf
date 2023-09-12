/*
    File: fn_medical_replaceItems.sqf
    Author: Savage Game Design
    Date: 2023-09-01
    Last Update: 2023-09-01
    Public: Yes

    Description:
        Replaces unit medical items with helper versions of them to prevent usage of vanilla healing action.

    Parameter(s):
        _unit - Unit to check for items [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_unit] call vgm_g_fnc_medical_replaceItems
 */

#define TYPE_FAK 401
#define TYPE_MEDIKIT 619

params ["_unit"];

private _cfgWeapons = configFile >> "CfgWeapons";

private _containerItemCounts = createHashMap;
{
    _containerItemCounts set [_x#0, _x#1]
} forEach [
    ["uniform",  uniqueUnitItems [_unit, 0, 2, 0, 0, false]],
    ["vest",     uniqueUnitItems [_unit, 0, 0, 2, 0, false]],
    ["backpack", uniqueUnitItems [_unit, 0, 0, 0, 2, false]]
];


private _fnc_replaceItem = {
    params ["_unit", "_container", "_item", "_replacement", "_amount"];

    format ["Replacing item: %1 | %2 | %3 | %4 | %5", _unit, _container, _item, _replacement, _amount] call vgm_g_fnc_logDebug;

    for "_i" from 1 to _amount do {
        switch (_container) do {
            case "uniform": {
                _unit removeItemFromUniform _item;
                _unit addItemToUniform _replacement;
            };
            case "vest": {
                _unit removeItemFromVest _item;
                _unit addItemToVest _replacement;
            };
            case "backpack": {
                _unit removeItemFromBackpack _item;
                _unit addItemToBackpack _replacement;
            };
        };
    };
};


{
    private _container = _x;
    private _itemCounts = _y;

    {
        private _item = _x;
        private _amount = _y;


        private _itemType = getNumber (_cfgWeapons >> _item >> "ItemInfo" >> "type");
        if (_itemType == TYPE_FAK) then {
            [_unit, _container, _item, "vn_helper_item_firstaidkit", _amount] call _fnc_replaceItem;
            continue;
        };
        if (_itemType == TYPE_MEDIKIT) then {
            [_unit, _container, _item, "vn_helper_item_medikit", _amount] call _fnc_replaceItem;
            continue;
        };
    } forEach _itemCounts;
} forEach _containerItemCounts;
