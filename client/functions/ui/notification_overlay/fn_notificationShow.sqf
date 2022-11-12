/*
	File: config.hpp
	Author:  Savage Game Design
	Public: No

	Description:
		Shows a notification on screen.
		@internal

	Parameter(s):
		_meta - Meta data [ARRAY]
		_data - Data [ARRAY]

	Returns:
		Control [CONTROL]

	Example(s): none
*/


private _duration = getNumber (missionConfigFile >> "Para_CfgNotifications" >> "animationDuration");
private _gap = getNumber (missionConfigFile >> "Para_CfgNotifications" >> "notificationGap");

params ["_meta", "_data"];
_meta params ["_id"];
_data params [
	"_title",
	"_body",
	"_icon",
	"_color",
	"_backgroundColor",
	"_sound"
];

private _display = localNamespace getVariable ["#para_c_var_notificationOverlay_display", displayNull];
private _control = _display ctrlCreate ["para_Notification", -1];


private _ctrlIcon = _control controlsGroupCtrl 121303;
_ctrlIcon ctrlSetText _icon;
_ctrlIcon ctrlSetTextColor _color;

private _ctrlTitle = _control controlsGroupCtrl 121304;
if (_icon isEqualTo "") then {
	_ctrlTitle ctrlSetPositionX 0;
	_ctrlTitle ctrlCommit 0;
};
_ctrlTitle ctrlSetText _title;
_ctrlTitle ctrlSetTextColor _color;


private _ctrlBackground = _control controlsGroupCtrl 121302;
_ctrlBackground ctrlSetBackgroundColor _backgroundColor;

private _ctrlBody = _control controlsGroupCtrl 121305;
_ctrlBody ctrlSetStructuredText (parseText _body);
if !(_body isEqualTo "") then {
	_control ctrlSetPositionH ((ctrlTextHeight _ctrlBody) + ((ctrlPosition _ctrlBackground)#3));
	_control ctrlCommit 0;
	_ctrlBody ctrlSetPositionH (ctrlTextHeight _ctrlBody);
	_ctrlBody ctrlCommit 0;
};

private _actives = localNamespace getVariable ["#para_c_var_notificationOverlay_actives", []];

private _actives = localNamespace getVariable ["#para_c_var_notificationOverlay_actives", []];
private _delta = _gap;
{
	(_x#0) params ["_xid", "_priority", "_minTTL", "_maxTTL", "_registered", "_shown", "_accelerated", "_expires", "_control"];
	if !(_xid isEqualTo _id) then {
		_delta = _delta + ((ctrlPosition _control)#3) + _gap;
	};
} forEach _actives;

_control ctrlSetPositionY (safeZoneY + (_delta + ((ctrlPosition _control)#3)));
_control ctrlSetFade 1;
_control ctrlCommit 0;

_control ctrlSetPositionY (safeZoneY + _delta);
_control ctrlSetFade 0;
_control ctrlCommit _duration;

if !(_sound isEqualTo "") then {
	playSound _sound;
};
_control
