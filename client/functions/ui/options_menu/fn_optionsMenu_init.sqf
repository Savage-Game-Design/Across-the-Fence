/*
	File: fn_optionsMenu_init.sqf
	Author:  Savage Game Design
	Public: Yes

	Description:
		Initialises the options menu.
	
	Parameter(s):
		None

	Returns: nothing

	Example(s):
		call para_c_fnc_optionsMenu_init:
*/

private _changeHandlers = createHashMap;
localNamespace setVariable ["para_optionsMenu_onChangeHandlers", _changeHandlers];

private _config = missionConfigFile >> "para_CfgOptions";
private _configs = "true" configClasses _config;

{
	private _configName = configName _x;
	private _changeHandler = compile getText (_x >> "onChange");

	/* Need to set this before we can setValue, as it fires the change handler */
	_changeHandlers set [_configName, _changeHandler];
	
	private _value = [_configName] call para_c_fnc_optionsMenu_getValue;

	/* setValue to make sure the onChange handler fires during initialisation */
	[_configName, _value] call para_c_fnc_optionsMenu_setValue;
} forEach _configs;