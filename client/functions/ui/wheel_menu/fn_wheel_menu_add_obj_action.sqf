/*
	File: fn_wheel_menu_add_obj_action.sqf
	Author:  Savage Game Design
	Public: Yes

	Description:
		Adds an action to the wheel menu.
		By using this with JIP, we can have a mixture of local actions and server-added actions, without the risk of the server overriding the client's actions.

	Parameter(s):
		_object - Object to add action to <OBJECT>
		_action - Action to add, see actions hashmap for reference <HASHMAP>

	Actions hashmap:
		condition - Whether or not the action should be displayed. <BOOL> or <CODE>
		iconPath - Path to the icon to show in the wheel menu <STRING>
		iconPathHighlighted - Path to the icon to show when item is highlighted <STRING>,
		functionArguments - Arguments to pass to the function being called. These will be available as the first item in the function's "_this" array. <ANY>
		text - Text to show in the menu. Can be a <STRING>, or an <ARRAY> in the format [Arguments, Code].
			   This will be called on the client for localization. Must return a <STRING>
		function - Name of the function to call <STRING>
		spawnFunction - Whether the function should be spawned or called <BOOL>
		selectorColorcodes - Colour of the selector. <ARRAY>, formatted: [<Colour Array>, <Colour Array>]. Optional.
		iconColorcodes - Colour of the icon. <ARRAY>, formatted: [<Colour Array>, <Colour Array>]. Optional

	Returns:
		Function reached the end [BOOL]

	Example(s): none
     
 */

params [
	"_object",
	"_action"
];

private _actions = _object getVariable ["para_wheel_menu_dyn_actions", []];

// Remove the _object, it'll be added dynamically later
_actions pushBack _action;

_object setVariable ["para_wheel_menu_dyn_actions", _actions];








