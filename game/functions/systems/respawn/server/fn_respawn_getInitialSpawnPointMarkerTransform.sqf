/*
    File: fn_respawn_getInitialSpawnPointMarkerTransform.sqf
    Author: Savage Game Design, Xorberax
    Public: Yes

    Description:
        Gets the transform of the marker named "initial_spawn_point".

    Parameter(s):
        NONE

    Returns:
        [
            PositionASL: ASL position of the "initial_spawn_point" marker,
            Direction: 0-360 degree direction of marker
        ]

    Example(s):
        _initialSpawnTransform = call vgm_s_fnc_respawn_getInitialSpawnPointMarkerTransform;
*/

#define MARKER_NAME "initial_spawn_point"

private _markerPositionASL = AGLToASL (getMarkerPos MARKER_NAME);
if (_markerPositionASL isEqualTo [0, 0, 0]) exitWith {
    [getPosASL player, direction player]; // TODO: remove before merge -- this is only for testing!!!
};
[_markerPositionASL, markerDir MARKER_NAME];
