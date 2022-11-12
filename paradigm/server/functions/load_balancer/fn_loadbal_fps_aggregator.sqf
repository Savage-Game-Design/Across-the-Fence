/*
	File: fn_loadbal_fps_aggregator.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Aggregates player FPSes into weighted arrays for use in the load balancer.

	Parameter(s): none

	Returns: nothing

	Example(s):
		call para_s_fnc_loadbal_fps_aggregator;
*/

// use HC or clients
private _allHeadlessClients = entities "HeadlessClient_F";
private _allPlayers = allPlayers - _allHeadlessClients;

private _allHeadlessClientsWeighted = flatten (_allHeadlessClients apply {
	[
		owner _x, 
		linearConversion [
			25,
			60,
			_x getVariable ["para_s_dyn_fps", 0],
			0,
			1,
			true
		]
	]
});

private _allPlayersWeighted = flatten (_allPlayers apply {
	[
		owner _x, 
		linearConversion [
			25,
			60,
			_x getVariable ["para_s_dyn_fps", 0],
			0,
			1,
			true
		]
	]
});

// update arrays
missionNamespace setVariable ["para_s_loadbal_hc_weighted",_allHeadlessClientsWeighted];
missionNamespace setVariable ["para_s_loadbal_players_weighted",_allPlayersWeighted];
