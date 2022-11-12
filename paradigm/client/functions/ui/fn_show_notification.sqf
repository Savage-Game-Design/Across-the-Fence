/*
	File: fn_show_notification.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Shows a notification, similar to BIS_fnc_showNotification
	
	Parameter(s):
		_config - Notification config [String]
		_templateArgs - Arguments passed to the templated strings in the config [Array, defaults to [] (empty array)]
	
	Returns: nothing

	Example(s):
		["NewSupportTask", ["", "Magical Support Task"]] call para_c_fnc_show_notification;
		["NewSupportTask", ["", "Magical Support Task"]] remoteExec ["para_c_fnc_show_notification", 0]
*/

params ["_config", ["_templateArgs", []]];

private _args = _templateArgs apply {_x call para_c_fnc_localize_and_format};

[_config, _args] call BIS_fnc_showNotification;