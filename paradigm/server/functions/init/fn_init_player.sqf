/*
	File: fn_init_player.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Runs the server-side initialisation scripts for Paradigm's init process.
		When done, marks the client as able to continue.
	
	Parameter(s):
		_player - Player to initialise [OBJECT]
		_didJIP - Whether the player joined in progress [BOOLEAN]
	
	Returns:
		None
	
	Example(s):
		[player, didJIP] remoteExecCall ["para_s_fnc_init_player", 2];
*/

params ["_player", "_didJIP"];

diag_log format ["Paradigm: Initialising player on the server - %1 - %2", _player, getPlayerUID _player];
private _owner = remoteExecutedOwner;
private _checkHC = (typeOf _player == "HeadlessClient_F");
if (!_checkHC && {_owner == 0 || owner _player == 0 || owner _player != remoteExecutedOwner}) exitWith {
		diag_log format ["Paradigm: Aborting player init, as player object is unowned - %1", _player];
	};

private _fnc_playerInitServer = compile preprocessFile "para_player_init_server.sqf";
[_player, didJIP] call _fnc_playerInitServer;

private _playerDisconnected = (owner _player != remoteExecutedOwner);
if (!_playerDisconnected || _checkHC) exitWith {
	diag_log format ["Paradigm: Player init completed, marking client as ready to continue - %1 - %2", _player, getPlayerUID _player];
	missionNamespace setVariable ["para_player_initialised", true, _owner];
};