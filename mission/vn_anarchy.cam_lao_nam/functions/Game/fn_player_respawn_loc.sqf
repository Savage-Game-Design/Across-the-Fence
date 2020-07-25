/*
  Author: Aaron Clark

  Description:
	returns correct location based on players group, works both server and client side

  Example Usage:
  	_player addMPEventHandler ["MPRespawn",{call vn_an_fnc_player_respawn_loc}];

  Returns:
	OBJECT - unit
	OBJECT - corpse

  Parameter(s):
*/
params ["_unit","_corpse"];

private _group_ID = _unit getVariable ["vn_an_player_group","MikeForce"];
private _respawn_loc = getMarkerPos "respawn_west_mikeforce";
private _respawn_loc_default = _respawn_loc;

// check for any friends to spawn on
private _uid = getPlayerUID _unit;
private _friends = _unit getVariable ["vn_an_friends",[]];

// check for online friends
if !(_friends isEqualTo []) then
{
	{
		private _friend = _x call BIS_fnc_getUnitByUid;
		if (!isNull _friend && {_uid in (_friend getVariable ["vn_an_friends",[]])}) exitWith
		{
			_respawn_loc = getPos _friend;
	};
	} forEach _friends;
};
// if no players found use respawn markers
if (_respawn_loc_default isEqualTo _respawn_loc) then
{
	if !(_group_ID isEqualTo "MikeForce") then
	{
		private _respawn_loc_team = getMarkerPos format["respawn_west_%1", toLower _group_ID];
		if !(_respawn_loc_team isEqualTo [0,0,0]) then
		{
			_respawn_loc = _respawn_loc_team;
		};
	};
};


// try to find a empty place to spawn
private _new_location = _respawn_loc findEmptyPosition [3,30,typeOf _unit];
if !(_new_location isEqualTo []) then
{
	_respawn_loc = _new_location;
};

["DEBUG:_respawn_loc %1 _group_ID %2", _respawn_loc, _group_ID] call BIS_fnc_logFormat;
_respawn_loc
