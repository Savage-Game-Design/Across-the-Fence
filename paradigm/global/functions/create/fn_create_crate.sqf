/*
	File: fn_create_crate.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Creates a crate of items.
	
	Parameter(s):
		_crateType - Type of crate to create [String]
	
	Returns:
		The crate object created [Object]
	
	Example(s):
		["RESUPPLY"] call para_g_fnc_create_crate;
*/

params ["_crateType"];

private _crate = ["B_CargoNet_01_ammo_F",  [0,0,0]] call para_g_fnc_create_vehicle;

//Empty all items from the crate.
clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;

//Add relevant items to the crate.
private _crateClass = (missionConfigFile >> "gamemode" >> "crates" >> _crateType);

if (!isClass _crateClass) exitWith {
	["Attempting to spawn invalid crate type %1", _crateType] call BIS_fnc_logFormat;
	objNull
};

private _weapons = getArray (_crateClass >> "weapons");
private _magazines = getArray (_crateClass >> "magazines");
private _items = getArray (_crateClass >> "items");
private _backpacks = getArray (_crateClass >> "backpacks");

{
	if (_x isEqualType [] && {count _x == 2} && {_x select 0 isEqualType ""} && {_x select 1 isEqualType 0}) then {
		_crate addWeaponCargoGlobal [_x select 0, _x select 1];
	};
} forEach _weapons;

{
	if (_x isEqualType [] && {count _x == 2} && {_x select 0 isEqualType ""} && {_x select 1 isEqualType 0}) then {
		_crate addMagazineCargoGlobal [_x select 0, _x select 1];
	};
} forEach _magazines;

{
	if (_x isEqualType [] && {count _x == 2} && {_x select 0 isEqualType ""} && {_x select 1 isEqualType 0}) then {
		_crate addItemCargoGlobal [_x select 0, _x select 1];
	};
} forEach _items;


{
	if (_x isEqualType [] && {count _x == 2} && {_x select 0 isEqualType ""} && {_x select 1 isEqualType 0}) then {
		_crate addBackpackCargoGlobal [_x select 0, _x select 1];
	};
} forEach _backpacks;

_crate
