/*
  Author: Aaron Clark

  Description:
	Downtick all players health each run

  Example Usage:
	call vn_an_fnc_player_health_stats;

*/
params [
	["_hunger_loss_factor",1.0],
	["_thirst_loss_factor",1.0],
	["_hunger_loss_rate",0.005],
	["_thirst_loss_rate",0.01],
	["_hunger_min",0],
	["_thirst_min",0],
	["_hunger_max",1],
	["_thirst_max",1],
	["_hunger_attributes_config",[[],[]]],
	["_thirst_attributes_config",[[],[]]]
];

private _prefix = "vn_an_";
private _config = (missionConfigFile >> "gamemode" >> "vars" >> "players");
private _blacklisted = getArray(_config >> "blacklisted");

{
	private _unit = _x;
	private _hunger = _unit getVariable ["vn_an_hunger",1];
	private _thirst = _unit getVariable ["vn_an_thirst",1];
	private _attributes = _unit getVariable ["vn_an_attributes",[]];
	// example of now to handle _attributes: if afflicted with a diuretic increase thirst loss 100%
	{
		if (_x in _attributes) then
		{
			_thirst_loss_factor = _thirst_loss_factor * ((_thirst_attributes_config select 1) select _forEachIndex);
		};
	} forEach (_thirst_attributes_config select 0);
	{
		if (_x in _attributes) then
		{
			_hunger_loss_factor = _hunger_loss_factor * ((_hunger_attributes_config select 1) select _forEachIndex);
		};
	} forEach (_hunger_attributes_config select 0);

	[_unit,"hunger",-(_hunger_loss_rate * _hunger_loss_factor)] call vn_an_fnc_change_player_stat;
	[_unit,"thirst",-(_thirst_loss_rate * _thirst_loss_factor)] call vn_an_fnc_change_player_stat;

	// force all players to save every 60 seconds to prevent roll back if server crashes
	_ticktime = diag_tickTime;
	_savetime = _unit getVariable ["vn_an_savetime",0];
	if (_ticktime > _savetime) then
	{
		_unit setVariable ["vn_an_savetime",_ticktime + 60];
		_uid = getPlayerUID _unit;
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

			[_unit,_uid,_vardata] call BIS_fnc_log;
		};
	};

} forEach allPlayers;
