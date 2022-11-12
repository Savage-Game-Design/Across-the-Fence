/*
	File: fn_optionsMenu_onUnload.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Handles the display unload.
	
	Parameter(s):
		_display - Display [DISPLAY]
		_exitCode - Display's exit code. 1 => OK, 2 => Cancel, 3 => Reset All [NUMBER]
	
	Returns: nothing
	
	Example(s): none
*/

params ["_display", "_exitCode"];

private _changes = _display getVariable ["#changes", []];

switch (_exitCode) do {
	case 1: {
		{
			_x params ["_configName", "_newValue"];
			[_configName, _newValue] call para_c_fnc_optionsMenu_setValue;
		} forEach _changes;
	};
	case 3: {
		private _config = missionConfigFile >> "para_CfgOptions";
		private _configs = "true" configClasses _config;
		{
			private _configName = getText (_x >> "variable");
			private _default = getNumber (_x >> "default");
			if (getText _config >> "type" isEqualTo "Checkbox") then {
				_default = [false, true] select _default;
			};
			[_configName, _default] call para_c_fnc_optionsMenu_setValue;
		} forEach _configs;
	};
	default {};
};

saveProfileNamespace;
