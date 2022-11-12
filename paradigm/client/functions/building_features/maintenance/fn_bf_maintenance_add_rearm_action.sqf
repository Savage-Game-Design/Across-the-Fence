/*
	File: fn_bf_maintenance_add_rearm_action.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Adds the "rearm vehicle" action to a building object.
	
	Parameter(s):
		_buildingObject - Object to add the action to [OBJECT]
	
	Returns:
		ID of the added action [STRING]
	
	Example(s):
		See building features config.
*/

params ["_buildingObject"];

_buildingObject addAction [
	"STR_para_bf_maintenance_rearm_action" call para_c_fnc_localize,
	{ ["bf_maintenance", ["rearm", _this select 0]] call para_c_fnc_call_on_server },
	[],
	1.5,
	true,
	true,
	"",
	"currentPilot vehicle player == player",
	10,
	false
];