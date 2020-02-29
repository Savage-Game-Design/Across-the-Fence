/*
  Author: Aaron Clark

  Description:
	deletes object and marks as removed in DB

  Example Usage:
	vn_mf_obj_pickup_1 call vn_mf_fnc_delete_building;

  Returns:
	NOTHING

  Parameter(s):
*/
params [
	"_obj" // 0: OBJECT - object to be deleted
];

private _configname = vehicleVarName _obj;

_obj setVariable ["removed", true];

private _variables = allVariables _obj;

private _vardata = [];
{
	_vardata pushBack [_x,(_obj getVariable _x)];
} forEach _variables;

["SET", (_configname + "_data"), _vardata] call vn_mf_fnc_hive;

// diag_log ("DEBUG delete_building:" + str _vardata);
["SAVE"] call vn_mf_fnc_hive;

deleteVehicle _obj;
