/*
	File: fn_deleteNotification.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Tries to delete a notification.
	
	Parameter(s):
		_id - Id of the notification to delete [NUMBER]
		_evenIfActive - Delete even if in the active queue [BOOLEAN, defaults to false]
	
	Returns:
		Has the notification been deleted [BOOLEAN]

	Example(s): [0, true] call para_c_fnc_deleteNotification
*/

params [
	"_id",
	["_evenIfActive", false, [false]]
];

private _queue = localNamespace getVariable ["#para_c_var_notificationOverlay_queue", []];
private _ids = _queue apply { _x#0#0 };
private _index = _ids findIf { _x isEqualTo _id };
if (_index >= 0) then {
	_queue deleteAt _index;
	localNamespace setVariable ["#para_c_var_notificationOverlay_queue", _queue];
	true;
} else {
	if (_evenIfActive) then {
		private _actives = localNamespace getVariable ["#para_c_var_notificationOverlay_actives", []];
		private _ids = _actives apply { _x#0#0 };
		private _index = _ids findIf { _x isEqualTo _id };
		if (_index >= 0) then {
			private _next = _actives#_index;
			_next params ["_meta", "_data"];
			_meta params ["_id", "_priority", "_minTTL", "_maxTTL", "_registered", "_shown", "_accelerated", "_expires", "_control"];
			_meta set [6, true];
			_meta set [7, 0];
			_actives set [_index, [_meta, _data]];
			localNamespace setVariable ["#para_c_var_notificationOverlay_actives", _actives];
			true;
		} else {
			false;
		};
	} else {
		false;
	};
};