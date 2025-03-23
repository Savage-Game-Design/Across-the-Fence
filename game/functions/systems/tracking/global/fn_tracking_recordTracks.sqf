/*
    File: fn_tracking_recordTracks.sqf
    Author: Savage Game Design
    Date: 2024-03-08
    Last Update: 2024-12-06
    Public: No

    Description:
        Records a new set of tracks for the given tracking group.
        Should be called periodically.

    Parameter(s):
        _trackingGroup - Trackin group to record tracks for [HASHMAP]

    Returns:
        Nothing

    Example(s):
        {
            [_x] call vgm_g_fnc_tracking_recordTracks;
        } forEach values vgm_l_tracking_trackingGroups;
 */

params ["_trackingGroup"];

private _groups = _trackingGroup get "groups";
private _trackDetails = _trackingGroup get "trackDetails";
private _trackPositions = _trackingGroup get "trackPositions";
private _lastTrackByUnit = _trackingGroup get "lastTrackByUnit";

private _totalUnits = 0;

{
    private _key = _x;
    private _group = _y;

    // Precaution against filling up with deleted groups
    if (isNull _group) then {
        _groups deleteAt _key;
        continue;
    };

    private _units = units _group;
    _totalUnits = _totalUnits + count _units;

    {
        private _pos = getPosATL _x;
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
            //["nextTrackVector", VECTOR]
            //["prevTrackVector", VECTOR]
        ];

        _trackPositions pushBack _pos;
        _trackDetails pushBack _details;
        _lastTrackByUnit set [hashValue _x, _details];

        // Effectively a one-direction linked list of tracks, so we can easily follow a trail.
        if (_distanceBetweenTracks < vgm_g_tracking_maxDistanceForSameTrail) then {
            private _prevTrackVector = ATLtoASL (_lastTrack get "pos") vectorDiff ATLtoASL _pos;
            _details set ["prevTrackVector", _prevTrackVector];
            _lastTrack set ["nextTrack", _details];
            _lastTrack set ["nextTrackVector", _prevTrackVector vectorMultiply -1];
        };
    } forEach _units;
} forEach _groups;

private _maxEntries = vgm_g_tracking_maxEntriesPerUnit * _totalUnits;
// Should be identical calculation for both arrays, as they should map 1-to-1.
private _toDelete = (count _trackPositions - _maxEntries) max 0;
_trackPositions deleteRange [0, _toDelete];
_trackDetails deleteRange [0, _toDelete];


