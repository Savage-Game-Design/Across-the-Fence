/*
 * File: fn_squad_west_spiketeam.sqf
 * Author: Spoffy
 * Description:
 *    Creates the unit array for a US spiketeam squad of a given size
 * Params:
 *    _unitsInSquad - Number of units to spawn.
 * Returns:
 *    Array of unit classes
 * Example Usage:
 *    Creates a spiketeam with 3 units
 *    [3] call vn_an_fnc_squad_west_spiketeam
 */

params ["_unitsInSquad"];

private _squad = [];
private _structure = [
	selectRandom units_sog_teamleader,
	selectRandom units_sog_rto,
	selectRandom units_sog_medic,
	selectRandom units_sog_scout,
	selectRandom units_sog_grenadier,
	selectRandom units_sog_scout,
	selectRandom units_sog_scout,
	selectRandom units_sog_machinegunner,
	selectRandom units_sog_scout
];

private _index = 0;
for "_i" from 1 to _unitsInSquad do {
	_squad pushBack (_structure select _index);
	_index = (_index + 1) mod (count _structure);
};

_squad