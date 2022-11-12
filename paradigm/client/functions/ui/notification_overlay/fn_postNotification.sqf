/*
	File: fn_postNotification.sqf
	Author:  Savage Game Design
	Public: Yes

	Description:
		Adds a notification to the queue to be display.

		Note: while body lenght is not limited, please do not go above 2 lines for the user's sake

	Parameter(s):
		_data - Data [ARRAY, defaults to []]
			_title - Title of the notification [STRING, defaults to ""]
			_body - Body of the notification, will be parseText'ed [STRING, defaults to ""]
			_icon - Icon of the notification [STRING, defaults to ""]
			_color - Title's text color [ARRAY, defaults to [0,0,0]]
				_r - Red [NUMBER]
				_g - Green [NUMBER]
				_b - Blue [NUMBER]
			_backgroundColor - Tilte's background color [ARRAY, defaults to [1,1,1]]
				_r - Red [NUMBER]
				_g - Green [NUMBER]
				_b - Blue [NUMBER]
			_sound - Sound played when showing the notification [STRING, defaults to ""]
		_meta - Meta [ARRAY, defaults to []]
			_priority - Priority (the higher, the more priority it has) [NUMBER, defaults to 0]
			_minTTL - Minimum time on screen [NUMBER, defaults to 5]
			_maxTTL - Maximum time on screen [NUMBER, defaults to 10]

	Returns:
		Notification ID - Unused [NUMBER]

	Example(s):
		[] spawn {
			uiSleep 1;
			[["#1", '<t color="#ff00ff">Tum</t> tu dum'], [0, 15, 25]] call para_c_fnc_postNotification;
			uiSleep 2;
			[["#2", "Notice me Senpai!", "\a3\ui_f\data\gui\cfg\hints\BasicLook_ca.paa", [1,1,1], [1,0,0]], [0, 10, 15]] call para_c_fnc_postNotification;
			uiSleep 2;
			[["#3", "GOATS", "", [1,1,1], [0,0,1]], [0, 15, 20]] call para_c_fnc_postNotification;
			uiSleep 1;
			[["#4"], [0, 5, 10]] call para_c_fnc_postNotification;
			[["#5"], [0, 5, 6]] call para_c_fnc_postNotification;
		};
*/


params [
	["_data", []],
	["_meta", []]
];

_data params [
	["_title", "", [""]],
	["_body", "", [""]],
	["_icon", "", [""]],
	["_color", [0,0,0], [[]], [3]],
	["_backgroundColor", [1,1,1], [[]], [3]],
	["_sound", "", [""]]
];

_title = _title call para_c_fnc_localize_and_format;
_body = _body call para_c_fnc_localize_and_format;

_color pushBack 1;
_backgroundColor pushBack 0.5;

_meta params [
	["_priority", 0, [0]],
	["_minTTL", 5, [0]],
	["_maxTTL", 10, [0]]
];

private _queue = localNamespace getVariable ["#para_c_var_notificationOverlay_queue", []];
private _lastId = localNamespace getVariable ["#para_c_var_notificationOverlay_lastId", 0];

private _newId = _lastId + 1;
private _item = [
	[_newId, _priority, _minTTL, _maxTTL, diag_tickTime, -1, false, -1, controlNull], // [_id, _priority, _minTTL, _maxTTL, _registered, _shown, _accelerated, _expires, _control]
	[_title, _body, _icon, _color, _backgroundColor, _sound]
];

// Insert the new notification where it belongs in the queue
private _newQueue = _queue;
reverse _newQueue;
private _mapped = _newQueue apply { _x#0#1 };
private _index = _mapped findIf { _x >= _priority };
if (_index isEqualTo -1) then {
	_newQueue pushBack _item;
} else {
	private _temp = [];
	_temp + (_newQueue select [0, _index]);
	_temp pushBack _item;
	_temp + (_newQueue select [_index, (count _newQueue) - _index]);
	_newQueue = _temp;
};
reverse _newQueue;


localNamespace setVariable ["#para_c_var_notificationOverlay_queue", _newQueue];
localNamespace setVariable ["#para_c_var_notificationOverlay_lastId", _newId];

call para_c_fnc_notificationManager;
_newId
