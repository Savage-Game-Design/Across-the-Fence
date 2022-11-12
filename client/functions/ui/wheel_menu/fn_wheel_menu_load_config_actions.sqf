/*
	File: fn_wheel_menu_load_config_actions.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Loads wheel menu actions from the config file.
	
	Parameter(s):
		None
	
	Returns:
		Function reached the end [BOOL]
	
	Example(s):
		[] call para_g_fnc_wheel_menu_load_config_actions
*/

private _configEntries = "getText (_x >> 'function') != ''" configClasses (missionConfigFile >> "wheel_menu_actions");

para_c_wheel_menu_actions_always = [];
para_c_wheel_menu_actions_no_target = [];

{
	private _config = _x;

	//We set this up to be passed as arguments to para_c_fnc_wheel_menu_add_obj_action
	private _action = createHashMap;

	if (isText (_config >> "condition")) then {
		_action set ["condition", compile getText (_config >> "condition")];
	};

	if (isText (_config >> "icon")) then {
		_action set ["iconPath", getText (_config >> "icon")];
	};

	if (isText (_config >> "icon_highlighted")) then {
		_action set ["iconPathHighlighted", getText (_config >> "icon_highlighted")];
	};

	if (isText (_config >> "arguments")) then {
		_action set ["functionArguments", compile getText (_config >> "arguments")];
	};

	if (isText (_config >> "function")) then {
		_action set ["function", getText (_config >> "function")];
	};

	if (isText (_config >> "text")) then {
		_action set ["text", getText (_config >> "text") call para_c_fnc_localize];
	};

	if (isNumber (_config >> "spawn")) then {
		_action set ["spawnFunction", getNumber (_config >> "spawn") > 0];
	};

	if (isArray (_config >> "color_codes")) then {
		_action set ["selectorColorCodes", getArray (_config >> "color_codes")];
	};

	if (isArray (_config >> "icon_color_codes")) then {
		_action set ["iconColorCodes", getArray (_config >> "icon_color_codes")];
	};

	private _visibility = getText (_config >> "visible");

	switch (_visibility) do {
		case "ALWAYS": {para_c_wheel_menu_actions_always pushBack _action};
		case "NO_TARGET": {para_c_wheel_menu_actions_no_target pushBack _action};
	};

	localNamespace setVariable [format ["para_c_wheel_menu_action_%1", configName _config], _action];
} forEach _configEntries;
