/*
 * File: fn_create_camp.sqf
 * Author: Spoffy
 * Description:
 *    Creates a hostile camp roughly at the given position.
 * Params:
 *    None
 * Returns:
 *    None
 * Example Usage:
 *    Example usage goes here
 */

params ["_position", "_unitQuantity"];

private _campfire = createVehicle ["Land_Fire_Burning", _position, [], 10, "NONE"];

private _patrolSize = 4;
private _groupCount = round (_unitQuantity / _patrolSize);

private _patrols = [];
for "_i" from 1 to _groupCount do {
	_patrols pushBack ([_position, 50, _patrolSize] call vn_an_fnc_patrol_create);
};

private _guards = [east] call vn_an_fnc_create_group;
for "_i" from 1 to 5 do {
	[_guards, selectRandom units_vc_basic, _position, [], 10, "NONE"] call vn_an_fnc_create_unit;
};

[_guards, _position] call BIS_fnc_taskDefend;

private _vehicles = [_campfire];
private _groups = [_guards] + _patrols;
private _units = [];
{
	_units append units _x;
} forEach _groups;

[[_vehicles, _units, _groups]]