/*
    File: fn_tracking_startRecordingTracks.sqf
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
