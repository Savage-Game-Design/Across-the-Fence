/*
    File: fn_zone_marker_update_info_position.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        INTERNAL USE. Updates the position of the zone tooltip.
    
    Parameter(s):
        _marker - Zone marker [STRING, defaults to nil]
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        ["zone_locationName"] call para_c_fnc_zone_marker_update_info_position;
*/
#include "..\..\..\configs\ui\ui_def_idc.inc"
params ["_marker"];
private _map = findDisplay 12;
private _ctrlMap = _map displayCtrl 51;
private _ctrlZoneMarkerInfo = _map displayCtrl PARA_RSCDISPLAYMAP_ZONEINFO_IDC;
//--- Make updates outside of view
_ctrlZoneMarkerInfo ctrlSetPosition [-10, -10, 1, 1];
_ctrlZoneMarkerInfo ctrlCommit 0;
//--- Display the info to the right of the marker
private _markerPosMap = _ctrlMap ctrlMapWorldToScreen ((getMarkerPos _marker) vectorAdd [selectMax (markerSize _marker apply {abs _x}), 0, 0]);
private _h = ctrlTextHeight _ctrlZoneMarkerInfo + 10 * pixelH;
_ctrlZoneMarkerInfo ctrlSetPosition [
	_markerPosMap select 0,
	(_markerPosMap select 1) - (_h / 2),
	_ctrlZoneMarkerInfo getVariable ["MaxTextWidth", 0],
	_h
];
_ctrlZoneMarkerInfo ctrlCommit 0;
true
