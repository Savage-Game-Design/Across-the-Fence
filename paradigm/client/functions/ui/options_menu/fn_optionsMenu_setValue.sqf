/*
	File: fn_optionsMenu_setValue.sqf
	Author:  Savage Game Design
	Public: Yes

	Description:
		Sets the value of an option, saving it in the profile namespace and triggering "onChange".

	Parameter(s):
		_configName - Config class of the option [STRING]

	Returns:
		Nothing

	Example(s):
		["para_minViewdist", _newValue] call para_c_fnc_optionsMenu_fireChangeHandler;
*/
params ["_configName", "_newValue"];

profileNamespace setVariable [format ["para_optionsMenu_%1", _configName], _newValue];
_newValue call (localNamespace getVariable "para_optionsMenu_onChangeHandlers" get _configName);