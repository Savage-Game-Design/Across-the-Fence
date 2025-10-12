/*
    File: fn_equipment_filterLoadout.sqf
    Author: Savage Game Design
    Date: 2023-11-17
    Last Update: 2025-09-18
    Public: Yes

    Description:
        Filters given loadout depending on items available to player.

    Parameter(s):
        _loadout - Loadout array <https://community.bistudio.com/wiki/Unit_Loadout_Array> [ARRAY]

    Returns:
        Loadout array [ARRAY]

    Example(s):
        [getUnitLoadout player] call vgm_c_fnc_equipment_filterLoadout
 */

private _allowedItems = createHashMapFromArray [["", nil]];
{
    if (!call compile (getText (_x >> "condition"))) then {continue};

    private _equipmentCfg = _x;
    {
        private _items = getArray (_equipmentCfg >> _x) apply {toLower _x};
        _allowedItems insert [true, _items, []];
    } forEach ["weapons", "magazines", "backpacks", "items"];

    // Add the base weapons to the allowed list. Necessary as the arsenal gives players base weapons, not `_sd` variants, etc.
    private _baseWeapons = getArray (_equipmentCfg >> "weapons") apply {toLower ([_x] call BIS_fnc_baseWeapon)};
    _allowedItems insert [true, _baseWeapons, []];
} forEach ("true" configClasses (missionConfigFile >> "vgm_equipment"));

private _removedItems = createHashMap;

private _fnc_filterWeapon = {
    params ["_weaponData"];
    {
        private _className = _x param [0, ""];
        if (!(toLower _className in _allowedItems)) then {
            private _replacement = ["", []] select (_x isEqualType []);
            _weaponData set [_forEachIndex, _replacement];
            _removedItems set [_className, []];
        };
    } forEach _weaponData;
};

private _fnc_filterContainer = {
    params [["_container", ""], ["_items", []]];

    if (!(toLower _container in _allowedItems)) exitWith {
        // remove the container from parent array
        _this resize 0;
    };

    {
        // Nested arrays should always be weapons
        if ((_x # 0) isEqualType []) then {
            [_x # 0] call _fnc_filterWeapon;
            continue;
        };

        // uniform/vest/backpack
        if (_x isEqualTypeArray ["", true]) then {
            _x params ["_itemClass", "_isBackpack"];
            // `getUnitLoadout` does not return content of nested containers
            // outright remove them for sake of simplicity
            _items set [_forEachIndex, []];
            _removedItems set [_itemClass, []];
            continue;
        };

        private _itemClass = _x select 0;
        if (!(toLower _itemClass in _allowedItems)) then {
            _items set [_forEachIndex, []];
            _removedItems set [_itemClass, []];
        };
    } forEach _items;
};

#define IDX_PRIMARY 0
#define IDX_SECONDARY 1
#define IDX_HANDGUN 2
#define IDX_UNIFORM 3
#define IDX_VEST 4
#define IDX_BACKPACK 5
#define IDX_HEADWEAR 6
#define IDX_FACEWEAR 7
#define IDX_BINOCULAR 8
#define IDX_ASSIGNED_ITEMS 9

params ["_loadout"];

_loadout = +_loadout;

// weapons
{
    private _itemData = _loadout select _x;
    [_itemData] call _fnc_filterWeapon;
} forEach [IDX_PRIMARY, IDX_SECONDARY, IDX_HANDGUN, IDX_BINOCULAR];

// containers
{
    private _containerData = _loadout select _x;
    _containerData call _fnc_filterContainer;
} forEach [IDX_UNIFORM, IDX_VEST, IDX_BACKPACK];

// items
{
    private _itemClass = _loadout select _x;
    if (!(toLower _itemClass in _allowedItems)) then {
        _loadout set [_x, ""];
        _removedItems set [_itemClass, []];
    };
} forEach [IDX_HEADWEAR, IDX_FACEWEAR];

private _assignedItems = _loadout select IDX_ASSIGNED_ITEMS;
{
    if (!(toLower _x in _allowedItems)) then {
        _assignedItems set [_forEachIndex, ""];
        _removedItems set [_x, []];
    };
} forEach _assignedItems;

[_loadout, keys _removedItems]
