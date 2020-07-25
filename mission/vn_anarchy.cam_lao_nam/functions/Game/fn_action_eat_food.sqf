/*
  Author: Aaron Clark

  Description:
	Adds action to eat food out of "rivers"

  Example Usage:
	call vn_an_fnc_action_eat_food;

  Returns:
	NUMBER - action id index

  Parameter(s):
	NA
*/
vn_an_foodeaten = 0;

[
	player,									// Object the action is attached to
	localize "STR_vn_an_eat_food",						// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",		// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",		// Progress icon shown on screen
	"(surfaceIsWater screenToWorld [0.5,0.5] && player distance screenToWorld [0.5,0.5] < 3)", // Condition for the action to be shown
	"player distance screenToWorld [0.5,0.5] < 3",				// Condition for the action to progress
	{player playMove "AinvPknlMstpSnonWnonDnon_healed_1"},			// Code executed when action starts
	{
		params ["_target", "_caller", "_action_id", "_arguments", "_progress", "_max_progress"];
		vn_an_foodeaten = vn_an_foodeaten + 0.1;
	},									// Code executed on every progress tick
	{
		[player,"eatfood",[vn_an_foodeaten],player getVariable "vn_an_token"] remoteExecCall ["vn_an_fnc_rehandler",2];
		player playMoveNow ""
			},							// Code executed on completion
	{
		[player,"eatfood",[vn_an_foodeaten - 0.1],player getVariable "vn_an_token"] remoteExecCall ["vn_an_fnc_rehandler",2];
		player playMoveNow ""
	},									// Code executed on interrupted
	[],									// Arguments passed to the scripts as _this select 3
	5,									// Action duration [s]
	100,									// Priority
	false,									// Remove on completion
	false									// Show in unconscious state
] call BIS_fnc_holdActionAdd;
