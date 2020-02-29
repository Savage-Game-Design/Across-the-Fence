/*
  Author: Aaron Clark

  Description:
	Displays location and gametime

  Example Usage:
	call vn_mf_fnc_display_location_time;

  Returns:
  	NOTHING

  Parameter(s):
  	NA
*/
private _nearestLocation = (markerText ([allMapMarkers, player] call BIS_fnc_nearestPosition)) call BIS_fnc_localize;
private _gametime = [vn_mf_totalgametime, "HH:MM"] call BIS_fnc_secondsToString;
[parseText format["<t font='VeteranTypewriter' size='1.6'>%1</t><br /><t font='VeteranTypewriter' size='1.0'>%2</t>",_nearestLocation,_gametime], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles;
