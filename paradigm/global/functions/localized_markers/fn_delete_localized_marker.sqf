/*
	File: fn_delete_localized_marker.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Deletes a localized marker with the given name
	
	Parameter(s):
		_markerName - Marker name [String]
	
	Returns: nothing

	Example(s): none
*/

params ["_markerName"];

remoteExec ["", format ["marker_localize_%1", _markerName]];

deleteMarker _markerName;