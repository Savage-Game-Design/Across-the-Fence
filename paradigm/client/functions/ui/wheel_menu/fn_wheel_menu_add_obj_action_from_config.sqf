/*
	File: fn_wheel_menu_add_obj_action_from_config.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Adds an action to the wheel menu, using data from the config.
		By using this with JIP, we can have a mixture of local actions and server-added actions, without the risk of the server overriding the client's actions.
	
	Parameter(s):
		_object - Object to add wheel menu item to [OBJECT]
		_actionName - Action name (class name from the config) [STRING]

	Returns:
		True if action was successfully added, false otherwise
	
	Example(s):
		[cursorObject, "open_door"] call para_c_fnc_wheel_menu_add_obj_action_fron_config
*/

params ["_object", "_actionName"];

private _action = localNamespace getVariable (format ["para_c_wheel_menu_action_%1", _actionName]);

if (isNil "_action") exitWith { false };

[_object, _action] call para_c_fnc_wheel_menu_add_obj_action;