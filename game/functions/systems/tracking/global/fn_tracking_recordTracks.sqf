/*
    File: fn_tracking_recordTracks.sqf
    Author:
    Date: 2024-03-08
    Last Update: 2024-03-08
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_trackingGroup"];

private _group = _trackingGroup get "group";
if (isNull _group) exitWith {
    [_trackingGroup get "hash"] call vgm_g_fnc_tracking_stopRecordingTracks;
};

private _units = units _group;
private _trackDetails = _trackingGroup get "trackDetails";
private _trackPositions = _trackingGroup get "trackPositions";
private _lastTrackByUnit = _trackingGroup get "lastTrackByUnit";

{
    private _pos = getPos _x;
    private _details =  createHashMapFromArray [
        // PosAGL of the track
        ["pos", _pos],
        // When the track was made
        ["time", serverTime],
        // Who made it
        ["unit", _x],
        // The next track in the series (we record this later)
        ["nextTrack", []]
    ];

    _trackPositions pushBack _pos;
    _trackDetails pushBack _details;

    // Effectively a one-direction linked list of tracks, so we can easily follow a trail.
    _lastTrackByUnit getOrDefault [hashValue _x, createHashMap] set ["nextTrack", _details];
    _lastTrackByUnit set [hashValue _x, _details];
} forEach _units;
