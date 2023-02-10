/*
    File: fn_respawn_getInitialSpawnPointMarkerPosition.sqf
    Author: Savage Game Design
    Public: Yes

    Description:
        Gets the ASL position of the marker named "initial_spawn_point".

    Parameter(s):
        NONE

    Returns:
        ASL position of the marker named "initial_spawn_point".

    Example(s):
        _initialSpawnPoint = call VGM_S_fnc_respawn_getInitialSpawnPointMarkerPosition;
*/

private _markerPositionASL = AGLToASL (getMarkerPos "initial_spawn_point");
if (_markerPositionASL isEqualTo [0, 0, 0]) exitWith {
    getPosASL player; // TODO: remove before merge -- this is only for testing!!!
};
_markerPositionASL;
