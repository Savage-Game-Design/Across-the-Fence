/*
    File: fn_net_action_add.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        Adds an action to an object that calls server-side code securely.
    
    Parameter(s):
        _object - Object to add action to [OBJECT]
		_title - Title of the action, in a format accepted by localize_and_format [ARRAY/STRING]
		_script - Script to execute when action is run [CODE]
		_arguments - Arguments to pass to the script [ARRAY]
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
		ID of the action, used to remove it. [STRING]
    
    Example(s):
		None
*/
params [
	"_object",
	"_title",
	"_script",
	["_arguments", []],
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

private _actionCount = missionNamespace getVariable ["para_s_netActionCount", 0];
missionNamespace setVariable ["para_s_netActionCount", _actionCount + 1];

private _id = (str _actionCount) + (str random 1000000);

#define KEY(keyName) ([_id, keyName] call para_g_fnc_net_action_varname)

//Save these as we'll need them later to execute the script, and validate it's allowed to run.
localNamespace setVariable [KEY("object"), _object];
localNamespace setVariable [KEY("arguments"), _arguments];
localNamespace setVariable [KEY("script"), _script];
localNamespace setVariable [KEY("condition"), compile _condition];
localNamespace setVariable [KEY("radius"), _radius];
localNamespace setVariable [KEY("unconscious"), _unconscious];

//Add the action locally to all clients, which will call the net_action callback serverside (no need to pass script).
[
	_id,
	_object,
	_title,
	_priority,
	_showWindow,
	_hideOnUse,
	_shortcut,
	_condition,
	_radius,
	_unconscious,
	_selection,
	_memoryPoint
] remoteExec ["para_c_fnc_net_action_add", 0, KEY("JIP")];

_object addEventHandler ["Deleted", compile format ["[%1] call para_s_fnc_net_action_remove", _id]];

_id