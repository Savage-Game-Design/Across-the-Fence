/*
    File: fn_init_player.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-01-29
    Last Update: 2020-06-12
    Public: No
    
    Description:
		Initialize player.
    
    Parameter(s):
		_player - Player [Object, defaults to objNull]
    
    Returns: nothing
    
    Example(s):
		[player] remoteExec ["vn_mf_fnc_init_player",2];
*/

params [
	["_player",objNull,[objNull]]			// 0 : OBJECT - player object making the call
];

// prevent repeated execution of init
private _current_token = _player getVariable "para_player_token";
if !(isNil "_current_token") exitWith {};

// check that player object making the call is the same as remoteExecutedOwner
private _owner = owner _player;
private _reowner = remoteExecutedOwner;
if (_owner isEqualTo 0 || _reowner isEqualTo 0) exitWith {};
if !(_owner isEqualTo _reowner) exitWith {};

private _uid = getPlayerUID _player;
(["GET", (_uid + "_data"), []] call para_s_fnc_profile_db) params ["","_object_data"];

private _config = (missionConfigFile >> "gamemode" >> "vars" >> "players");
private _public_vars = getArray(_config >> "publicvars");
private _blacklisted_vars = getArray(_config >> "blacklisted");

_local_vars = [];
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
				_local_vars pushBack [_varname,_vardata];
				_player setVariable [_varname,_vardata];
			};
		};
	} forEach _object_data;
};

// broadcast new token to only this player
private _token = random 99999;
_local_vars pushBack ["para_player_token",_token];
_player setVariable ["para_player_token",_token];


// set new enlisted number
private _enlisted = _player getVariable ["vn_mf_db_serial","0"];
if (_enlisted isEqualTo "0") then {
	private _warcodes = [51,52,53,54,55,56];
	// increment enlisted count server side
	vn_mf_enlisted_counter = vn_mf_enlisted_counter + 1;
	["SET", "enlisted_counter", vn_mf_enlisted_counter] call para_s_fnc_profile_db;
	private _serial = format["US %1 %2",selectRandom _warcodes,vn_mf_enlisted_counter];
	_local_vars pushBack ["vn_mf_db_serial",_serial];
	_player setVariable ["vn_mf_db_serial",_serial];

};

// last group
private _group_ID = _player getVariable ["vn_mf_db_player_group","MikeForce"];
// join player to last known group
private _selected_group = missionNamespace getVariable [_group_ID,grpNull];
// check that group is found and is proper type

if (!isNull _selected_group && {_selected_group isEqualType grpNull}) then
{
	["Joining player to team %1, with group %2", _group_ID, _selected_group] call BIS_fnc_logFormat;
	[_player, _selected_group] call vn_mf_fnc_force_team_change;
} else
{
	"DEBUG: ERROR - group does not exist!!!" call BIS_fnc_log
};

// load last loadout
(["GET", (_uid + "_loadout"), []] call para_s_fnc_profile_db) params ["","_loadout"];
if !(_loadout isEqualTo []) then
{
	_player setUnitLoadout [_loadout, false];
};

// restore players rank
([_player] call vn_mf_fnc_unit_to_rank) params ["", "_rank", ""];
_rank = toUpper _rank;
if !(rank _player isEqualTo _rank) then
{
	_player setUnitRank _rank;
};

// start player at correct camp for team
_player setPos ([_player,_player] call vn_mf_fnc_player_respawn_loc);

// respawn event for respawning player at correct camp for team
_player addMPEventHandler ["MPRespawn",{call vn_mf_fnc_player_respawn_loc}];

// add event handlers from the harass subsystem.
[_player] call para_s_fnc_harass_add_player_event_handlers;

// send all variables to player
[_local_vars] remoteExecCall ["vn_mf_fnc_set_local_var",_player];

// execute stage 2 of login
[] remoteExec ["vn_mf_fnc_start_game_stage2",_player];

_player setVariable ["vn_mf_dyn_issetup", true];

["uid %1 _object_data %2", _uid,_object_data] call BIS_fnc_logFormat;
