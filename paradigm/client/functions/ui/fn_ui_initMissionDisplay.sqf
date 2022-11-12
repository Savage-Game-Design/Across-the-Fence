/*
	File: fn_ui_initMissionDisplay.sqf
	Author: Karel Moricky, improved by Killzone_Kid, modifed by Terra for Mikeforce
	Public: No
	
	Description:
		Init GUI display and run its script for the onLoad or onUnload UIEH from config.
		The config class of the display is available in "BIS_fnc_initDisplay_configClass" stored on display
			Example: _display getVariable "BIS_fnc_initDisplay_configClass";
		Display is also stored in uiNamespace variable with config class name
			Example: uiNamespace getVariable "RscAvCamera";
	
	Parameter(s):
		_mode - "onLoad" or "onUnload" UIEH from display config [STRING, defaults to ""]
		_params - UIEH parameters [ARRAY, defaults to []]
		_class - Display classname [STRING, defaults to ""]
		_path - UI variable to keep track of opened displays [STRING, defaults to "default"]
		_register - Save display to uiNamespace variable [BOOL, defaults to true]
	
	Returns:
		nil
	
	Example(s):
		// Only use in display config
		onLoad = ["onLoad", _this, "RscDisplayEmpty"] call para_fnc_ui_initMissionDisplay;
*/
#define CONFIG_CLASS_VAR "BIS_fnc_initDisplay_configClass"

//--- Register/unregister display
params 
[
	["_mode", "", [""]],
	["_params", []],
	["_class", "", [""]],
	["_path", "default", [""]],
	["_register", true, [true, 0]]
];

_display = _params param [0, displayNull];
if (isNull _display) exitWith {nil};

if (_register isEqualType true) then {_register = parseNumber _register};
if (_register > 0) then 
{
	_varDisplays = _path + "_displays";
	_displays = (uiNamespace getVariable [_varDisplays, []]) - [displayNull];

	if (_mode == "onLoad") exitWith 
	{
		//--- Register current display
		_display setVariable [CONFIG_CLASS_VAR, _class];
		uiNamespace setVariable [_class, _display];
		
		_displays pushBackUnique _display;
		uiNamespace setVariable [_varDisplays, _displays];
	};
	
	if (_mode == "onUnload") exitWith 
	{
		//--- Unregister current display
		_displays = _displays - [_display];
		uiNamespace setVariable [_varDisplays, _displays];
	};
};

//TODO - Make this work with something other than the para_c_fnc prefix
[_mode, _params, _class] call (missionNamespace getVariable ("para_c_fnc_" + _class));
nil