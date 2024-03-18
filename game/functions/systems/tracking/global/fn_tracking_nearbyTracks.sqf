/*
    File: fn_tracking_nearbyTracks.sqf
    Author: Savage Game Design
    Date: 2024-03-08
    Last Update: 2024-03-18
    Public: Yes

    Description:
        Retrieves tracks within the specified radius of the provided position.

    Parameter(s):
        _trackingGroupId - Tracking group whose tracks should be searched [STRING]
        _position - Position to search around (2D) [ARRAY]
        _distance - Radius to search for tracks [NUMBER]

    Returns:
        Array of track detail hashmaps [ARRAY]

    Example(s):
        ["1", getPos player, 30] call vgm_g_fnc_tracking_nearbyTracks;
 */

params ["_trackingGroupId", "_position", "_distance"];

if !(_trackingGroupId in vgm_l_tracking_trackingGroups) exitWith { [] };

private _trackingGroup = vgm_l_tracking_trackingGroups get _trackingGroupId;

private _nearbyIndexes = (_trackingGroup get "trackPositions")
    inAreaArrayIndexes [_position, _distance, _distance, 0, false];

private _trackDetails = _trackingGroup get "trackDetails";

_nearbyIndexes apply { _trackDetails # _x }
