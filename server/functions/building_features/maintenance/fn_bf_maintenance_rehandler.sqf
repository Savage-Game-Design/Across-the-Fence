/*
	File: fn_bf_maintenance_rehandler.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Called from rehandler to trigger a vehicle repair.
	
	Parameter(s):
		_buildingObject - The building object that was used to trigger the repair [OBJECT]
	
	Returns:
		None
	
	Example(s):
		["bf_maintenance", ["repair", cursorObject]] call para_c_fnc_call_on_server
*/

params ["_action", "_buildingObject"];

private _vehicle = vehicle _player;
if (currentPilot _vehicle != _player) exitWith {};

if (_action == "repair") exitWith
{
	[_vehicle, _buildingObject] call para_s_fnc_bf_maintenance_repair_vehicle;
};

if (_action == "refuel") exitWith
{
	[_vehicle, _buildingObject] call para_s_fnc_bf_maintenance_refuel_vehicle;
};

if (_action == "rearm") exitWith
{
	[_vehicle, _buildingObject] call para_s_fnc_bf_maintenance_rearm_vehicle;
};
