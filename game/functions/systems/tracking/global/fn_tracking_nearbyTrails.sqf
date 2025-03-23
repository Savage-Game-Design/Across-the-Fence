/*
    File: fn_tracking_nearbyTrails.sqf
    Author: Savage Game Design
    Date: 2024-03-08
    Last Update: 2024-12-06
    Public: Yes

    Description:
        A more specific version of nearbyTracks.

        Fetches all tracks in a given radius, then filters them based on the player's distance
        to the lines between them.

    Parameter(s):
        _trackingGroupId - Tracking group whose tracks should be searched [STRING]
        _position - Position to search around (2D or 3D PosATL) [ARRAY]
        _trackDistance - Radius to search for tracks. Larger will give better results, at the cost of performance. [NUMBER]
        _trailDistance - Maximum distance from the trail [NUMBER]

    Returns:
        Array of track detail hashmaps [ARRAY]

    Example(s):
        ["1", getPos player, 30, 10] call vgm_g_fnc_tracking_nearbyTrails;
 */

params ["_trackingGroupId", "_position", "_trackDistance", "_trailDistance"];

private _nearbyTracks = [_trackingGroupId, _position, _trackDistance] call vgm_g_fnc_tracking_nearbyTracks;

private _results = [];

{
    private _track = _x;
    {
        if !(_x in _track) then { continue; };
        private _nearestPoint = [ATLtoASL _position, ATLtoASL (_track get "pos"), _track get _x] call vgm_g_fnc_nearestPointOnLine;
        if (_nearestPoint isNotEqualTo [] and {_nearestPoint distance2D _position < _trailDistance}) then {
            _results pushBack [_track, ASLtoATL _nearestPoint];
        };
    } forEach ["nextTrackVector", "prevTrackVector"];
} forEach _nearbyTracks;

_results
