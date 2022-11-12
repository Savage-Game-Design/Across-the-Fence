/*
	File: config.hpp
	Author:  Savage Game Design
	Public: No

	Description:
		Updates active notifications position.
		@internal

	Parameter(s): none

	Returns: nothing

	Example(s): none
*/


private _actives = localNamespace getVariable ["#para_c_var_notificationOverlay_actives", []];

private _duration = getNumber (missionConfigFile >> "Para_CfgNotifications" >> "animationDuration");
private _gap = getNumber (missionConfigFile >> "Para_CfgNotifications" >> "notificationGap");

private _delta = _gap;
{
	(_x#0) params ["_id", "_priority", "_minTTL", "_maxTTL", "_registered", "_shown", "_accelerated", "_expires", "_control"];
	_control ctrlSetPositionY (safeZoneY + _delta);
	_delta = _delta + ((ctrlPosition _control)#3) + _gap;
	_control ctrlCommit _duration;
} forEach _actives;
