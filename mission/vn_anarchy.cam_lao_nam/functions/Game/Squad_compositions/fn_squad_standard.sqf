/*
 * File: fn_squad_standard.sqf
 * Author: Spoffy
 * Description:
 *    Creates the unit array for a standard squad of a given size
 * Params:
 *    _unitsInSquad - Number of units to spawn.
 * Returns:
 *    Array of unit classes
 * Example Usage:
 *    Creates a standard infantry squad with 3 units
 *    [3] call vn_an_fnc_squad_standard
 */

params ["_unitsInSquad"];

private _squad = [];
private _structure = [
	selectRandom units_vc_officer,
	selectRandom units_vc_basic,
	selectRandom units_vc_grenadier,
	selectRandom units_vc_medic,
	selectRandom units_vc_marksman,
	selectRandom units_vc_at,
	selectRandom units_vc_mg,
	selectRandom units_vc_basic,
	selectRandom units_vc_smg,
	selectRandom units_vc_basic,
	selectRandom units_vc_basic
];

private _index = 0;
for "_i" from 1 to _unitsInSquad do {
	_squad pushBack (_structure select _index);
	_index = (_index + 1) mod (count _structure);
};

_squad