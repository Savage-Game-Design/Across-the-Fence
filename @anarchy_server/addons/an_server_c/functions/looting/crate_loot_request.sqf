/*
	File: fn_crate_loot_request.sqf
	Author: Aaron Clark <vbawol>
	Date: 2020-07-20
	Last Update: 2020-09-02
	Public: No

	Description:
		Code to do loot container request RE from client

	Parameter(s):
		None

	Returns:
		Nothing

	Example(s):
		call AN_C_fnc_crate_loot_request;
*/
params ["_pos", "_building"];

private _player_ID = getPlayerUID _player;
private _chance = 0.99;
private _max_dist = 20;

if !(isNull _building) then
{
	private _building_type = typeOf _building;
	private _building_type_config = (missionConfigFile >> "gamemode" >> "looting" >> "buildings" >> _building_type);
	private _loot_per_crate = getNumber(_building_type_config >> "count");
	if (_loot_per_crate > 0) then
	{
		if (_pos distance2D _building < _max_dist) then
		{
			if (_player distance2D _pos < _max_dist) then
			{
				// check if loot pos is real
				_seed = (vn_an_seed + (floor _pos#2));
				if (_seed random [(floor _pos#0),(floor _pos#1)] > _chance) then
				{
					// do loot type lookup based on building class
					_crate_type = getText(_building_type_config >> "type");
					_crate_seed = (str vn_an_seed) + (_pos joinString "");
					// do call to ASC to make crate and spawn loot.
					diag_log [":::: CRATE_LOOT_REQUEST: DATA:", ["call_function", ["crate_data_get",[_player_ID, _pos, _crate_seed, _crate_type] ] ]];
					/*
						0 - STR - playerID
						1 - ARRAY - pos of crate
						2 - STR - global seed
						3 - STR - Type of loot to spawn
						4 - INT - Indicator (for the Backend) if it is a Loot-crate or not (1 = fill with loot | 0 = add nothing) - "1" also overrides a given gridSize!
						5 - INT - Optional Argument: set this, to override the standard value of min. "2" items bein created (Result can still be higher, depending on the Players "scavenging"-skill)
					*/
					["crate_data_get", [_player_ID, _pos, _crate_seed, _crate_type, _loot_per_crate]] call AN_G_fnc_msg_send;
				}else{
					diag_log "ERROR: FUNCTION: crate_loot_request: (_seed random [(_pos#0),(_pos#1)] > _chance)";
				};
			} else {
				diag_log ("player too far way! crate pos:" + str _pos + " ppos: " +  str getPosASL player + " dist: " + str (_player distance2D _pos));
			};
		} else {
			diag_log ("building too far way! crate pos:" + str _pos + " ppos: " +  str getPosASL player + " dist: " + str (_player distance2D _pos));
		};
	}else{
		diag_log "ERROR: Building: " + _building_type + " not allowed to spawn loot!";
	};
}else{
	diag_log "ERROR: FUNCTION: crate_loot_request: !(isNull _building)";
};
