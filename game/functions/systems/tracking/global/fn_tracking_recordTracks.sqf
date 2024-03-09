/*
    File: fn_tracking_recordTracks.sqf
    Author:
    Date: 2024-03-08
    Last Update: 2024-03-09
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

private _groups = _trackingGroup get "groups";
private _trackDetails = _trackingGroup get "trackDetails";
private _trackPositions = _trackingGroup get "trackPositions";
private _lastTrackByUnit = _trackingGroup get "lastTrackByUnit";

{
    private _key = _x;
    private _group = _y;

    // Precaution against filling up with deleted groups
    if (isNull _group) then {
        _groups deleteAt _key;
        continue;
    };

    private _units = units _group;

    {
        private _pos = getPos _x;
        private _lastTrack = _lastTrackByUnit getOrDefault [hashValue _x, createHashMap];

        private _distanceBetweenTracks = _pos distance2D (_lastTrack getOrDefault ["pos", [-1000, -1000, 0]]);

        // Enforce a minimum distance between tracks, so we don't end up with a pile of tracks in one location.
        if (_distanceBetweenTracks < vgm_g_tracking_minDistanceBetweenTracks) then {
            continue;
        };

        private _details =  createHashMapFromArray [
            // PosAGL of the track
            ["pos", _pos],
            // When the track was made
            ["time", serverTime],
            // Who made it
            ["unit", _x]
            // The next track in the series (we record this later)
            //["nextTrack", HASHMAP]
        ];

        _trackPositions pushBack _pos;
        _trackDetails pushBack _details;
        _lastTrackByUnit set [hashValue _x, _details];

        // Effectively a one-direction linked list of tracks, so we can easily follow a trail.
        if (_distanceBetweenTracks < vgm_g_tracking_maxDistanceForSameTrail) then {
            _lastTrack set ["nextTrack", _details];
        };
    } forEach _units;
} forEach _groups;
