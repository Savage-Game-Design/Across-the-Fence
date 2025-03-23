/*
    File: fn_equipment_setDefaultLoadout.sqf
    Author: Savage Game Design
    Date: 2024-12-05
    Last Update: 2024-12-05
    Public: Yes

    Description:
        Set default Gamemode loadout on an unit.

    Parameter(s):
        _unit - Unit to set loadout on [OBJECT]

    Returns:
        Nothing

    Example(s):
        player call vgm_c_fnc_equipment_setDefaultLoadout
 */

#define EMPTY_LOADOUT [[],[],[],[],[],[],"","",[],["","","","","",""]]

params [
    ["_unit", objNull, [objNull]]
];

_unit setUnitLoadout EMPTY_LOADOUT;

private _cfgEquipment = missionConfigFile >> "vgm_equipment";

_unit addUniform getText (_cfgEquipment >> "startingUniform");
_unit addVest getText (_cfgEquipment >> "startingVest");
_unit addBackpack getText (_cfgEquipment >> "startingBackpack");

{_unit linkItem _x} forEach getArray (_cfgEquipment >> "startingItems");

_unit addWeapon (getArray (_cfgEquipment >> "startingBinocular")#0);
_unit addBinocularItem (getArray (_cfgEquipment >> "startingBinocular")#1);

{
    _x params [["_weapon", ""], ["_weaponItems", []]];

    if (_weapon != "") then {_unit addWeapon _weapon};
    {
        _x params ["_item", ["_count", 1]];
        for "_i" from 1 to _count do {
            if (_weapon != "" && _i == 1) then {
                _unit addWeaponItem [_weapon, _item, true]
            } else {
                _unit addItem _item;
            };
        };
    } forEach _weaponItems;
} forEach getArray (_cfgEquipment >> "startingWeaponItems");
