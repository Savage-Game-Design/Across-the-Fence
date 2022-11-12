/*
	File: config.hpp
	Author:  Savage Game Design
	Public: No
	
	Description:
		Handles notification stuff.
		@internal
	
	Parameter(s): none
	
	Returns: nothing
	
	Example(s): none
*/


private _refresh = getNumber (missionConfigFile >> "Para_CfgNotifications" >> "refresh");

private _actives = localNamespace getVariable ["#para_c_var_notificationOverlay_actives", []];
private _queue = localNamespace getVariable ["#para_c_var_notificationOverlay_queue", []];

while { !(_actives isEqualTo []) || !(_queue isEqualTo []) } do {
	private _toDelete = [];
	{
		(_x#0) params ["_id", "_priority", "_minTTL", "_maxTTL", "_registered", "_shown", "_accelerated", "_expires", "_control"];;
		if (diag_tickTime >= _expires) then {
			_toDelete pushBack _forEachIndex;
		};
	} forEach _actives;

	private _move = 0;
	{
		private _notification = (localNamespace getVariable ["#para_c_var_notificationOverlay_actives", []])#(_x - _move);
		[_x - _move, _notification] call para_c_fnc_notificationHide;
		(localNamespace getVariable ["#para_c_var_notificationOverlay_actives", []]) deleteAt (_x - _move);
		_move = _move + 1;
	} forEach _toDelete;

	if !(_toDelete isEqualTo []) then para_c_fnc_notificationUpdate;
	para_c_fnc_NotificationNext forEach _toDelete;

	_actives = localNamespace getVariable ["#para_c_var_notificationOverlay_actives", []];
	_queue = localNamespace getVariable ["#para_c_var_notificationOverlay_queue", []];
	uiSleep _refresh;
};
