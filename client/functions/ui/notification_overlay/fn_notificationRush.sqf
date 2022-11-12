/*
	File: fn_notificationRush.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Find and accelerates an active notification.
		@internal

	Parameter(s): none

	Returns: nothing

	Example(s): none
*/


_fnc_indexOfMin = {
	private _number = _this#0;
	private _index = 0;
	private _x = 0;
	for "_i" from 1 to ((count _this) -1) do {
		_x = _this#_i;
		if (_x < _number) then { _number = _x; _index = _i };
	};
	_index;
};

private _actives = localNamespace getVariable ["#para_c_var_notificationOverlay_actives", []];
private _nonAccelerated = _actives select { !(_x#0#6) };
if !(_nonAccelerated isEqualTo []) then {
	private _next = _nonAccelerated#((_nonAccelerated apply { (_x#0#5) + (_x#0#2) }) call _fnc_indexOfMin);
	_next params ["_meta", "_data"];
	_meta params ["_id", "_priority", "_minTTL", "_maxTTL", "_registered", "_shown", "_accelerated", "_expires", "_control"];
	_meta set [6, true];
	_meta set [7, (_shown + _minTTL)];
	private _insert = _actives findIf { (_x#0#0) isEqualTo _id };
	_actives set [_insert, [_meta, _data]];
	localNamespace setVariable ["#para_c_var_notificationOverlay_actives", _actives];
};
