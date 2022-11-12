/*
	File: fn_net_action_add.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Adds an action to an object that calls server-side code securely.
	
	Parameter(s):
		_id - ID of the networked action to add to the object [STRING]
		_object - Object to add action to [OBJECT]
		_title - Title of the action, in a format accepted by localize_and_format [ARRAY/STRING]
		_priority - Priority of the action [NUMBER]
		_showWindow - Whether or not to show the title in the middle of the screen [BOOLEAN]
		_hideOnUse - Whether or not to hide the action menu after use [BOOLEAN]
		_shortcut - Keyboard shortcut for the action [STRING]
		_condition - Condition that must return true for the action to be shown. Must be valid on both client and server. [STRING]
		_radius - Radius for the action to appear in. [NUMBER]
		_unconscious - Whether or not it's shown to an incapacitated player [BOOLEAN]
		_selection - Geometry LOD's named selection [STRING]
		_memoryPoint - Object's memory point [STRING]
	
	Returns:
		None
	
	Example(s):
		//See para_s_fnc_net_action_add
*/
params [
	"_id",
	"_object",
	"_title",
	["_priority", 1.5],
	["_showWindow", true],
	["_hideOnUse", true],
	["_shortcut", ""],
	["_condition", ""],
	["_radius", 50],
	["_unconscious", false],
	["_selection", ""],
	["_memoryPoint", ""]
];



private _localId = _object addAction [
	_title call para_c_fnc_localize_and_format,
	{ ["net_action_fire", [_this select 3]] call para_c_fnc_call_on_server},
	_id,
	_priority,
	_showWindow,
	_hideOnUse,
	_shortcut,
	_condition,
	_radius,
	_unconscious,
	_selection,
	_memoryPoint
];

localNamespace setVariable [[_id, "actionId"] call para_g_fnc_net_action_varname, [_object, _localId]];