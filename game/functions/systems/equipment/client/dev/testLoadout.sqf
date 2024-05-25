/*
[player] call compileScript ["functions\systems\equipment\client\dev\testLoadout.sqf"];
*/

params ["_unit"];

#define EMPTY_LOADOUT [[],[],[],[],[],[],"","",[],["","","","","",""]]

_unit setUnitLoadout EMPTY_LOADOUT;

_unit addBackpack "vn_b_pack_02";

private _backpack = backpackContainer _unit;
_backpack addBackpackCargoGlobal ["vn_b_pack_02", 2];

_backpack addItemCargoGlobal ["vn_b_uniform_sog_01_01", 1];

firstBackpack _backpack addItemCargoGlobal ["vn_b_uniform_sog_01_01", 1];
