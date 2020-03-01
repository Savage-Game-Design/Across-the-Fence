/*
  Author: Aaron Clark

  Description:
	Save player vars on disconnect

  Parameter(s):
*/
params [
	"_unit",
	"_id",
	"_uid",
	"_name"
];
private _prefix = "vn_an_";

private _config = (missionConfigFile >> "gamemode" >> "vars" >> "players");
private _blacklisted = getArray(_config >> "blacklisted");

private _vardata = [];
if !(isNull _unit) then
{
	// remove blacklisted vars
	private _all_player_vars = (allVariables _unit) - _blacklisted;
	// filter for proper prefix and populate array to be saved
	{
		_vardata pushBack [_x,(_unit getVariable _x)];
	} forEach (_all_player_vars select {_x find _prefix == 0});

	// save data
	["SET", (_uid + "_data"), _vardata] call vn_an_fnc_hive;

	// save players loadout
	["SET", (_uid + "_loadout"), getUnitLoadout _unit] call vn_an_fnc_hive;

	// delete unit
	deleteVehicle _unit;
};

["%1 _vardata %2",_this, _vardata] call BIS_fnc_logFormat;

false
