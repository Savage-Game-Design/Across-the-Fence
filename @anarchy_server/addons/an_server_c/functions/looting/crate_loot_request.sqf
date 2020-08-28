
params ["_pos", "_building"];

// Get the player obj from remoteExecutedOwner
private _allPlayers = allPlayers - entities "HeadlessClient_F";
private _owner_index = _allPlayers findIf { (owner _x) isEqualTo remoteExecutedOwner};
if(_owner_index < 0)exitWith{diag_log "ERROR: crate_loot_request: Player not found in allPlayers!"};

private _player = _allPlayers#_owner_index;
private _player_ID = getPlayerUID _player;
private _chance = 0.99;
private _max_dist = 20;
private _building_type = typeOf _building;
if !(isNull _building) then
{
	if (_pos distance2D _building < _max_dist) then
	{
		if (_player distance2D _pos < _max_dist) then
		{
			// check if loot pos is real
			_seed = (vn_an_seed + (_pos#2));
			if (_seed random [(_pos#0),(_pos#1)] > _chance) then
			{
				// todo do loot type lookup based on building class _building_type
				_crate_type = "type_military";
				_crate_seed = (str vn_an_seed) + (_pos joinString "");
				// todo do call to ASC to make crate and spawn loot.
				diag_log [":::: CRATE_LOOT_REQUEST: DATA:", ["call_function", ["crate_data_get",[_player_ID, _pos, _crate_seed, _crate_type] ] ]];
				// Last Entry is the Indicator, for the Backend, if it is a Loot-crate or not (1 = fill with loot | 0 = add nothing)
				["crate_data_get", [_player_ID, _pos, _crate_seed, _crate_type, 1]] call AN_G_fnc_msg_send;
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
	diag_log "ERROR: FUNCTION: crate_loot_request: !(isNull _building)";
};
