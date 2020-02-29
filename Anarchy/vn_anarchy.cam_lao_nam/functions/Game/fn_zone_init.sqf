/*
  Author: Aaron Clark

  Description:
	loads and initialize zones

  Example Usage:
	call vn_mf_fnc_zone_init;

  Returns:
	NOTHING

*/
{
	if (_x find "fob_" isEqualTo 0) then
	{
		_x setMarkerAlpha 0;
	};
	if (_x find "fsb_" isEqualTo 0) then
	{
		_x setMarkerAlpha 0;
	};
	if (_x find "zone_" isEqualTo 0) then
	{
		// hide location markers used for mission mockup
		private _location_markers = (_x splitString "_");
		_location_markers deleteAt 0;
		private _location_marker = _location_markers joinString "_";
		_location_marker setMarkerAlpha 0;

		// get data about zone progress
		private _zone_progress_key = (_x + "progress");
		(["GET", _zone_progress_key, 0] call vn_mf_fnc_hive) params ["","_zone_progress"];

		// create progress marker
		private _mainMarkerPos = getMarkerPos _x;
		private _progressMarker = createMarker [_zone_progress_key, _mainMarkerPos];
		_progressMarker setMarkerShape "ICON";
		_progressMarker setMarkerType "hd_dot";
		_progressMarker setMarkerText format["%1%2",_zone_progress toFixed 0,"%"];
		private _colorStr = [_zone_progress] call vn_mf_fnc_progress_to_color_config;
		_x setMarkerColor _colorStr;

		// hide if zone is not started yet
		if (_zone_progress isEqualTo 0) then
		{
			_progressMarker setMarkerAlpha 0;
			_x setMarkerAlpha 0;
		};

		missionNamespace setVariable [_zone_progress_key, _zone_progress];
	};
} forEach allMapMarkers;

vn_mf_activeZones = [];
["zone_ba_ria"] call vn_mf_fnc_zone_make_active;