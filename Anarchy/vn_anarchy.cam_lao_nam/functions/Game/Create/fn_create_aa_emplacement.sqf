/*
 * File: fn_create_aa_emplacement.sqf
 * Author: Spoffy
 * Description:
 *    Creates an AA emplacement (NVA) at the specified position.
 * Params:
 *    _position - Position where to roughly spawn the AA emplacement
 * Returns:
 *   [[Vehicles created, units created, groups created], [AA Guns created]]
 * Example Usage:
 *   [[0,0,0], 10] call vn_mf_fnc_create_aa_emplacement
 */

params ["_position", "_unitCount"];

private _crewedAAGun = [_position, 0, "uns_ZPU4_NVA", east] call BIS_fnc_spawnVehicle;

private _vehicles = [_crewedAAGun select 0];
private _units = _crewedAAGun select 1;
private _groups = [_crewedAAGun select 2];

private _patrolSize = 2;
private _groupCount = floor (_unitCount / _patrolSize);

for "_i" from 1 to _groupCount do {
	_groups pushBack ([_position, 35, _patrolSize, east] call vn_mf_fnc_patrol_create);
};

private _units = [];

{
	_units append units _x;
} forEach _groups;

[[_vehicles, _units, _groups], [_crewedAAGun select 0]]