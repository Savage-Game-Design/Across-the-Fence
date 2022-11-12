/*
	File: config.hpp
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Hides a notification.
		@internal
	
	Parameter(s):
		_index - Where is the notification on the screen [NUMBER]
		_notification - Notification [ARRAY]
	
	Returns: nothing
	
	Example(s): none
*/


params [
	"_index",
	"_notification"
];

_notification params [
	"_meta",
	"_data"
];

_meta params ["_id", "_priority", "_minTTL", "_maxTTL", "_registered", "_shown", "_accelerated", "_expires", "_control"];

private _actives = localNamespace getVariable ["#para_c_var_notificationOverlay_actives", []];

private _pos = ctrlPosition _control;

private _duration = getNumber (missionConfigFile >> "Para_CfgNotifications" >> "animationDuration");

// if ((_index isEqualTo 0) || (_index isEqualTo ((count _actives) - 1))) then {
if (_index isEqualTo 0) then {
	_control ctrlSetPositionY (safeZoneY - _pos#3);
	_control ctrlSetFade 1;
	_control ctrlCommit _duration;
} else {
	_control ctrlSetPositionX (_pos#0 + _pos#2);
	_control ctrlSetFade 1;
	_control ctrlCommit _duration;
};

_control spawn {
	private _duration = getNumber (missionConfigFile >> "Para_CfgNotifications" >> "animationDuration");
	uiSleep _duration;
	ctrlDelete _this;
};
