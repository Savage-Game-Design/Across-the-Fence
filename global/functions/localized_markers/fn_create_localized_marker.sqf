/*
	File: fn_create_localized_marker.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Creates a localised marker at the given position.
	
	Parameter(s):
		_markerName - Name of the marker [String]
		_position - Position of the marker [Position2D]
		_key - String table entry or script that returns a string [Array|Code]
	
	Returns: nothing
	
	Example(s): none
*/

params ["_markerName", "_position", "_key"];

private _marker = createMarker [_markerName, _position];

[
	[_marker, _key],
	{
		params ["_marker", "_key"];
		private _text = if (_key isEqualType []) then {(_key select 0) call (_key select 1)} else {_key call para_c_fnc_localize};
		_marker setMarkerTextLocal _text;
	}
] remoteExec ["call", 0, format ["marker_localize_%1", _markerName]];