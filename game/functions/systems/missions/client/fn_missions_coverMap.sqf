/*
    File: fn_missions_coverMap.sqf
    Author: Bohemia Interactive, Savage Game Design
    Date: 2024-08-23
    Last Update: 2024-08-23
    Public: Yes

    Description:
        Covers map with an overlay limitng the map area to current mission.
        If no current mission removes the overlay.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_fnc_missions_coverMap;
 */

private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;

if (isNil "_currentMission") exitWith {
    for "_i" from 0 to 270 step 90 do {
        private _marker = format ["vgm_fnc_coverMap_%1",_i];
        deleteMarkerLocal _marker;
        _marker = format ["vgm_fnc_coverMap_dot_%1",_i];
        deleteMarkerLocal _marker;
    };
    deleteMarkerLocal "vgm_fnc_coverMap_border";
};

private _zone = _currentMission get "targetZone";
markerPos _zone params ["_posX", "_posY"];
markerSize _zone params ["_sizeX", "_sizeY"];
private _dir = markerDir _zone;

_sizeOut = 50000;

for "_i" from 0 to 270 step 90 do {
    private _size1 = [_sizeX,_sizeY] select (abs cos _i);
    private _size2 = [_sizeX,_sizeY] select (abs sin _i);
    private _sizeMarker = [_size2,_sizeOut] select (abs sin _i);
    private _dirTemp = _dir + _i;
    private _markerPos = [
        _posX + (sin _dirTemp * _sizeOut),
        _posY + (cos _dirTemp * _sizeOut)
    ];

    [_i,_markerPos,[_sizeMarker,_sizeOut - _size1]] call bis_fnc_log;

    private _marker = format ["vgm_fnc_coverMap_%1",_i];
    createMarkerLocal [_marker,_markerPos];
    _marker setMarkerPosLocal _markerPos;
    _marker setMarkerSizeLocal [_sizeMarker,_sizeOut - _size1];
    _marker setMarkerDirLocal _dirTemp;
    _marker setMarkerShapeLocal "rectangle";
    _marker setMarkerBrushLocal "solid";
    _marker setMarkerColorLocal "colorBlack";


    _markerPos = [
        _posX + (sin _dirTemp * _size1) + (sin (_dirTemp + 90) * _size2),
        _posY + (cos _dirTemp * _size1) + (cos (_dirTemp + 90) * _size2)
    ];
    _marker = format ["vgm_fnc_coverMap_dot_%1",_i];
    createMarkerLocal [_marker,_markerPos];
    _marker setMarkerPosLocal _markerPos;
    _marker setMarkerSizeLocal [0.75,0.75];
    _marker setMarkerDirLocal _dir;
    _marker setMarkerTypeLocal "mil_box_noShadow";
    _marker setMarkerColorLocal "colorBlack";
};

//--- Frame
private _marker = "vgm_fnc_coverMap_border";
createMarkerLocal [_marker, markerPos _zone];
_marker setMarkerPosLocal markerPos _zone;
_marker setMarkerSizeLocal [_sizeX,_sizeY];
_marker setMarkerDirLocal _dir;
_marker setMarkerShapeLocal "rectangle";
_marker setMarkerBrushLocal "border";
_marker setMarkerColorLocal "colorblack";
