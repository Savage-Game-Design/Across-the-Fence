/*
    File: fn_tracking_startRecordingTracks.sqf
    Author: Savage Game Design
    Date: 2024-03-08
    Last Update: 2024-03-18
    Public: Yes

    Description:
        Starts recording tracks for the given Arma group, as a part of the tracking group with the given ID.

        Creates a new tracking group if one doesn't exist with the given ID.

    Parameter(s):
        _trackingGroupId - Tracking group to create or add to [STRING]
        _group - Group to start tracking the units in [GROUP]

    Returns:
        Nothing

    Example(s):
        ["myMission", group player] call vgm_g_fnc_tracking_startRecordingTracks;
 */

params ["_trackingGroupId", "_group"];

private _trackingGroup = vgm_l_tracking_trackingGroups get _trackingGroupId;

if (isNil "_trackingGroup") then {
    _trackingGroup = createHashMapFromArray [
        ["id", _trackingGroupId],
        // Groups being tracked
        ["groups", createHashMap],
        // Information about a specific recorded track
        ["trackDetails", []],
        // The position of each track. Its index in this array is the same the track's index in trackDetails.
        ["trackPositions", []],
        // The last track a unit placed down.
        ["lastTrackByUnit", createHashMap]
    ];

    vgm_l_tracking_trackingGroups set [_trackingGroupId, _trackingGroup];
};

_trackingGroup get "groups" set [hashValue _group, _group];
_group setVariable ["vgm_l_tracking_trackingGroupId", _trackingGroupId];

_group addEventHandler ["Deleted", {
    params ["_group"];

    [_group getVariable "vgm_l_tracking_trackingGroupId", _group] call vgm_g_fnc_tracking_stopRecordingTracks;
}];
