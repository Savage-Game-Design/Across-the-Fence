/*
	File: fn_bf_wreck_recovery_cooldown_check.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Tell the cooldown time for building's wreck recovery feature.
	
	Parameter(s):
		_building - The building object that was used to trigger the recovery [OBJECT]
	
	Returns:
		Number of seconds until next recovery. [INTEGER]
	
	Example(s):
		[_building] call para_g_fnc_bf_wreck_recovery_cooldown_check;
*/

params ["_building"];

private _nextUsageTimestamp = _building getVariable ["bf_wreck_nextUsageTimestamp", 0];

if (_nextUsageTimestamp isEqualTo 0) exitWith { 0; };

private _currentTime = diag_tickTime;
private _deltaTime = _nextUsageTimestamp - _currentTime;

_deltaTime;
