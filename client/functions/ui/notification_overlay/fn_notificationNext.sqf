/*
	File: fn_notificationManager.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Prepare and trigger the display of the next notification.
		@internal
	
	Parameter(s): none
	
	Returns: nothing
	
	Example(s): none
*/


private _queue = localNamespace getVariable ["#para_c_var_notificationOverlay_queue", []];
if (_queue isEqualTo []) exitWith {};

private _notification = _queue deleteAt 0;

if (_notification isEqualTo []) exitWith {}; // Uhm... yeah?
private _control = _notification call para_c_fnc_notificationShow;

_notification params ["_meta", "_data"];
_meta params ["_id", "_priority", "_minTTL", "_maxTTL", "_registered", "_shown", "_accelerated", "_expires", "_xcontrol"];
_meta set [5, diag_tickTime]; // Set the _shown
_meta set [7, diag_tickTime + _maxTTL]; // Set the expiration
_meta set [8, _control]; // Set the control

private _actives = localNamespace getVariable ["#para_c_var_notificationOverlay_actives", []];
_actives pushBack [_meta, _data];
localNamespace setVariable ["#para_c_var_notificationOverlay_actives", _actives];
localNamespace setVariable ["#para_c_var_notificationOverlay_queue", _queue];
