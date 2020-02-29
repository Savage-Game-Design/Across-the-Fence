/*
  Author: Aaron Clark

  Description:
	placed building handler

  Example Usage:
	not called directly

  Passed: _player : OBJECT - player reference

  Returns:
	Nothing

  Parameter(s):
*/
params [
	["_object",objNull,[objNull]],
	["_configname","",[""]]
];

["_configname %1 _object %2", _configname,_object] call BIS_fnc_log;

// sets 3 hour decay on just placed objects
private _building_supplies = ["difficulty", "building_supplies", 10080] call vn_mf_fnc_get_gamemode_value;
_object setVariable ["vn_mf_buildstate",(vn_mf_totalgametime + _building_supplies),true];
_object setVariable ["vn_mf_buildclass",_configname];

// add building to array for tracking
vn_mf_buildings pushBack _object;
