/*
	File: fn_bf_wreck_recovery_availablity_check.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Wreck recovery asset job
	
	Parameter(s):
		_building - The building object that was used to trigger the recovery [OBJECT]
		_respawnTime - Sets the cooldown time for the building... generally set by config. [INTEGER]
		_vehicleName - Name of vehicle that triggered the recovery [STRING]
	
	Returns:
		BOOLEAN

	Example(s):
		[_building, _respawnTime, _vehicleName] call para_s_fnc_bf_wreck_recovery_availablity_check;
*/

params ["_building", "_respawnTime", "_vehicleName"];

if !([_building] call para_g_fnc_building_is_functional) exitWith
{
	false
};

private _onCooldown = [_building] call para_g_fnc_bf_wreck_recovery_cooldown_check; //See if it has a cooldown.
if (_onCooldown > 0) exitWith {
	false
};

private _cost = _respawnTime * 3;
private _usedSupplies = [_building, _cost] call para_s_fnc_building_consume_supplies;
if !(_usedSupplies) exitWith
{
	false
};

_building setVariable ["bf_wreck_recoverName", _vehicleName];
_building setVariable ["bf_wreck_nextUsageTimestamp", diag_tickTime + _respawnTime];
true


