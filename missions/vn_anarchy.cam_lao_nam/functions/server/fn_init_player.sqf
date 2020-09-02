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
		[player] remoteExec ["vn_an_fnc_init_player",2];
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
// todo load peristant data here

// broadcast new token to only this player
private _token = random 99999;
_local_vars pushBack ["para_player_token",_token];
_player setVariable ["para_player_token",_token];


// start player at correct camp for team
// _player setPos ([_player,_player] call vn_mf_fnc_player_respawn_loc);

// respawn event for respawning player at correct camp for team
// _player addMPEventHandler ["MPRespawn",{call vn_mf_fnc_player_respawn_loc}];

// add event handlers from the harass subsystem.
// [_player] call para_s_fnc_harass_add_player_event_handlers;

// send all variables to player
[_local_vars] remoteExecCall ["para_c_fnc_set_local_var",_player];

// execute stage 2 of login
[] remoteExec ["vn_an_fnc_start_game_stage2",_player];

_player setVariable ["vn_mf_dyn_issetup", true];

["uid %1 _object_data %2", _uid,_object_data] call BIS_fnc_logFormat;
