/*
	File: fn_optionsMenu_getValue.sqf
	Author:  Savage Game Design
	Public: Yes

	Description:
		Gets the current value, if the user hasn't modified the settings, returns the default.

	Parameter(s):
		_name - Name of the option [STRING]

	Returns:
		Value [NUMBER]

	Example(s):
		["Test"] call para_c_fnc_getValue; // 0
*/

params ["_configName"];

private _config = missionConfigFile >> "para_CfgOptions" >> _configName;
private _default = getNumber (_config >> "default");
private _type = getText (_config >> "type");

private _result = profileNamespace getVariable [format ["para_optionsMenu_%1", _configName], _default];

if (_type isEqualTo "Checkbox" && _result isEqualType 0) then {
	_result = _result > 0;
};

_result