/*
  Author: Aaron Clark

  Description:
	returns correct location based on players group, works both server and client side

  Example Usage:
  	_player addMPEventHandler ["MPRespawn",{call vn_mf_fnc_player_respawn_loc}];

  Returns:
	OBJECT - unit
	OBJECT - corpse

  Parameter(s):
*/
params ["_unit","_corpse"];

private _group_ID = _unit getVariable ["vn_mf_player_group","MikeForce"];
private _respawn_loc = getMarkerPos "respawn_west_mikeforce";

// check for any friends to spawn on
private _uid = getPlayerUID _unit;
private _friends = _unit getVariable ["vn_mf_friends",[]];
private _all_players = allPlayers;
_respawn_loc_player = [];
if !(_friends isEqualTo []) then
{
	private _index = _all_players findIf {(getPlayerUID _x) in _friends && {_uid in (_x getVariable ["vn_mf_friends",[]])}};
	if (_friend_found > -1) then
	{
		_friendly_player = _all_players select _index;
		_respawn_loc_player = getPos _friendly_player;
	};
};
// if no players found use respawn markers
if (_respawn_loc_player isEqualTo []) then
{
	if !(_group_ID isEqualTo "MikeForce") then
	{
		private _respawn_loc_team = getMarkerPos format["respawn_west_%1", toLower _group_ID];
		if !(_respawn_loc_team isEqualTo [0,0,0]) then
		{
			_respawn_loc = _respawn_loc_team;
		};
	};
}
else
{
	_respawn_loc = _respawn_loc_player;
};


// try to find a empty place to spawn
private _new_location = _respawn_loc findEmptyPosition [3,30,typeOf _unit];
if !(_new_location isEqualTo []) then
{
	_respawn_loc = _new_location;
};

diag_log format["DEBUG:_respawn_loc %1 _group_ID %2", _respawn_loc, _group_ID];
_respawn_loc
