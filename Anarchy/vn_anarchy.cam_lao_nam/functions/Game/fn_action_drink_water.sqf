/*
  Author: Aaron Clark

  Description:
	Adds action to drink water out of "rivers"

  Example Usage:
	call vn_mf_fnc_action_drink_water;

  Returns:
	NUMBER - action id index

  Parameter(s):
*/

// [findDisplay 46,36,5, {hint "Key 'J' pressed for 5 seconds"; player playMove "AinvPknlMstpSnonWnonDnon_healed_1"}] call BIS_fnc_holdKey;

vn_mf_waterdrank = 0;
[
	player,											// Object the action is attached to
	localize "STR_vn_mf_drink_water",							// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",	// Progress icon shown on screen
	"(surfaceIsWater screenToWorld [0.5,0.5] && player distance screenToWorld [0.5,0.5] < 3)",						// Condition for the action to be shown
	"player distance screenToWorld [0.5,0.5] < 3",						// Condition for the action to progress
	{player playMove "AinvPknlMstpSnonWnonDnon_healed_1"},													// Code executed when action starts
	{
		params ["_target", "_caller", "_action_id", "_arguments", "_progress", "_max_progress"];
		vn_mf_waterdrank = vn_mf_waterdrank + 0.1;
	},													// Code executed on every progress tick
	{
		private _payload = [vn_mf_waterdrank,"water"];
		[player,"drinkwater",_payload,player getVariable "vn_mf_token"] remoteExecCall ["vn_mf_fnc_rehandler",2];
		player playMoveNow ""
	},				// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	5,													// Action duration [s]
	100,													// Priority
	false,											// Remove on completion
	false												// Show in unconscious state
] call BIS_fnc_holdActionAdd;
