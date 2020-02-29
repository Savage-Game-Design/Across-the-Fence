/*
  Author: Aaron Clark

  Description:
	resupply building

  Example Usage:
	not called directly

  Passed: _player : OBJECT - player reference

  Returns:
	Nothing

  Parameter(s):
*/
params [
	["_object",objNull,[objNull]]
];

private _nearby_supplies = _object nearEntities ["I_supplyCrate_F", 20];

private _supplies = (_object getVariable ["vn_mf_buildstate",0]) - vn_mf_totalgametime;

private _building_decay = ["difficulty", "building_decay_time", 259200] call vn_mf_fnc_get_gamemode_value;
private _building_supplies = ["difficulty", "building_supplies", 10080] call vn_mf_fnc_get_gamemode_value;

{
    _supplies = _supplies + _building_supplies;
    deleteVehicle _x;
} forEach _nearby_supplies;

_object setVariable ["vn_mf_buildstate",(vn_mf_totalgametime + (_supplies min _building_decay)),true];
