/*
  Author: Aaron Clark

  Description:
	initalize player

  Example Usage:
	[player] remoteExec ["vn_an_fnc_init_player",2];

  Parameter(s):
*/
params [
	["_player",objNull,[objNull]]			// 0 : OBJECT - player object making the call
];

// prevent repeated execution of init
private _current_token = _player getVariable "vn_an_token";
if !(isNil "_current_token") exitWith {};

// check that player object making the call is the same as remoteExecutedOwner
private _owner = owner _player;
private _reowner = remoteExecutedOwner;
if (_owner isEqualTo 0 || _reowner isEqualTo 0) exitWith {};
if !(_owner isEqualTo _reowner) exitWith {};

private _uid = getPlayerUID _player;
(["GET", (_uid + "_data"), []] call vn_an_fnc_hive) params ["","_object_data"];

private _config = (missionConfigFile >> "gamemode" >> "vars" >> "players");
private _public_vars = getArray(_config >> "publicvars");
private _blacklisted_vars = getArray(_config >> "blacklisted");

if !(_object_data isEqualTo []) then
{
	{
		_x params ["_varname","_vardata"];
		if (!isNil "_vardata" && !(_varname in _blacklisted_vars)) then
		{
			if (_varname in _public_vars) then
			{
				// set everwhere
				_player setVariable [_varname,_vardata,true];
			}
			else
			{
				// set only on server and client
				_player setVariable [_varname,_vardata,[2,owner _player]];
			};
		};
	} forEach _object_data;
};

// broadcast new token to only this player
private _token = random 99999;
_player setVariable ["vn_an_token",_token,[2,owner _player]];

// last group
private _group_ID = _player getVariable ["vn_an_player_group","MikeForce"];
// join player to last known group
private _selected_group = missionNamespace getVariable [_group_ID,grpNull];
// check that group is found and is proper type

if (!isNull _selected_group && {_selected_group isEqualType grpNull}) then
{
	// join group
	[_player] joinSilent _selected_group;
} else
{
	diag_log "DEBUG: ERROR - group does not exist!!!"
};


// load last loadout
(["GET", (_uid + "_loadout"), []] call vn_an_fnc_hive) params ["","_loadout"];
if !(_loadout isEqualTo []) then
{
	_player setUnitLoadout [_loadout, false];
};

// restore players rank
([_player] call vn_an_fnc_unit_to_rank) params ["", "_rank", ""];
_rank = toUpper _rank;
if !(rank _player isEqualTo _rank) then
{
	_player setUnitRank _rank;
};

// start player at correct camp for team
_player setPos ([_player,_player] call vn_an_fnc_player_respawn_loc);

// respawn event for respawning player at correct camp for team
_player addMPEventHandler ["MPRespawn",{call vn_an_fnc_player_respawn_loc}];

// execute stage 2 of login
[] remoteExec ["vn_an_fnc_start_game_stage2",_player];

diag_log format["vn_an_fnc_init_player %1 _object_data %2", _this,_object_data];

[_player] call vn_an_fnc_task_refresh_task_list;

// start gamemode 5 seconds after first player joins
if (isNil "vn_an_gamestarted") then
{
	vn_an_gamestarted = true;
	0 spawn {
		sleep 5;
		call vn_an_fnc_task_init;
	}
};
