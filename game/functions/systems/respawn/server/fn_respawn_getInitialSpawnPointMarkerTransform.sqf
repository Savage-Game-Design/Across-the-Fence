/*
    File: fn_respawn_getInitialSpawnPointMarkerTransform.sqf
    Author: Savage Game Design, Xorberax
    Public: No

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
    private _errorMessage = format ["MISSION CONFIGURATION ERROR: %1 marker is undefined! The mission author must place a marker named ""%1"" to give players a fallback position to respawn at (see vgm_s_fnc_respawn_getInitialSpawnPointMarkerTransform).", MARKER_NAME];
    ["ERROR", _errorMessage] call para_g_fnc_log;
    systemChat _errorMessage;
    hint _errorMessage;

    [getPosASL player, direction player];
};
[_markerPositionASL, markerDir MARKER_NAME];
