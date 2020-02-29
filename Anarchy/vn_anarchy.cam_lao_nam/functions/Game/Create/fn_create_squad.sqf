/*
 * File: fn_create_squad.sqf
 * Author: Spoffy
 * Description:
 *    Spawns units given as a parameter, assigns them to a group.
 * Params:
 *    _units - Array of unit classes ["vn_unit_etc"]
 *    _groupTarget - Group to put units in, or side to create units in.
 *    _position - Position to spawn units around
 * Returns:
 *    [[units], group]
 * Example Usage:
 *    ["vn_test", west] call vn_mf_fnc_create_squad
 */

params [["_units", []], "_groupTarget", "_position"];

private _group = _groupTarget;

if (typeName _groupTarget == "SIDE") then {
	_group = [_groupTarget, true] call vn_mf_fnc_create_group;
};

private _spawnedUnits = _units apply {[_group, _x, _position, [], 5, "NONE"] call vn_mf_fnc_create_unit};

[_spawnedUnits, _group]