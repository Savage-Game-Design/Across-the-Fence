/*
  Author: Aaron Clark

  Description:
	Spawns object and loads related data

  Example Usage:
	[_class, [["zone_ba_ria"], ["water"]] ,_configname] call vn_mf_fnc_spawn_object;

  Parameter(s):
	NA

  Returns:
	NOTHING

*/

//code
params ["_class", ["_randompos",[]], ["_configname",""]];

_pos = _randompos;
if !(_randompos isEqualTo []) then
{
	_pos = _randompos call BIS_fnc_randomPos;
};

_object = createVehicle [_class, _pos, [], 0, "NONE"];

missionNamespace setVariable [_configname, _object];
_object setVehicleVarName _configname;

_object
