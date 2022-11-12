/*
    File: fn_zone_marker_init.sqf
    Author:  Savage Game Design
    Public: Yes

    Description:
        Sets up the zone marker system. Zone markers display information about
        a given zone in the map when the player hovers above a given marker,
        that was added with para_c_fnc_zone_markerAdd.

    Parameter(s):
        None

    Returns:
        Function reached the end [BOOL]

    Example(s):
        [] call para_c_fnc_zone_marker_init;
*/
#include "..\..\..\configs\ui\ui_def_idc.inc"
private _ctrlZoneMarkerInfo = findDisplay 12 ctrlCreate ["RscStructuredText", PARA_RSCDISPLAYMAP_ZONEINFO_IDC];
_ctrlZoneMarkerInfo ctrlSetPosition [-10, -10, 1, 1];
_ctrlZoneMarkerInfo ctrlSetBackgroundColor [0,0,0,1];
_ctrlZoneMarkerInfo ctrlSetTextColor [1,1,1,1];
_ctrlZoneMarkerInfo ctrlShow false;
para_c_fnc_zone_marker_mapEH = addMissionEventHandler ["Map", {
    params ["_opened", "_isForced"];
    if (!_opened) exitWith {};

    addMissionEventHandler ["EachFrame", {
        if (!visibleMap) exitWith {
            [] call para_c_fnc_zone_marker_hide_info;
            removeMissionEventHandler ["EachFrame", _thisEventHandler];
        };

        private _map = findDisplay 12;
        private _ctrlMap = _map displayCtrl 51;
        private _mouseMapPos = _ctrlMap ctrlMapScreenToWorld getMousePosition;
        private _markerKeyArray = keys para_c_zone_markers_map;
        //--- Find a zone marker where the mouse position currently is in
        private _markersAtPos = _markerKeyArray select {
            _mouseMapPos inArea [getMarkerPos _x, getMarkerSize _x select 0, getMarkerSize _x select 1, 0, false]
        };

        if (count _markersAtPos != 0) then {
            private _markerSelection = "";
            {
              if (_x find "base_" != -1) exitWith {
                _markerSelection = _markersAtPos select _forEachIndex;
              };
              _markerSelection = _markersAtPos select ((count _markersAtPos) - 1);
            } forEach _markersAtPos;
            [_markerSelection] call para_c_fnc_zone_marker_show_info;
        } else {
            [] call para_c_fnc_zone_marker_hide_info;
        };
        para_c_fnc_zone_marker_latestSelectedMarker = _zoneMarker;
    }];
}];
true
