/*
    File: fn_tracking_startRecordingTracks.sqf
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

params ["_group"];

private _hash = hashValue _group;

vgm_l_tracking_groups set [_hash, createHashMapFromArray [
    ["hash", _hash],
    ["group", _group],
    // Information about a specific recorded track
    ["trackDetails", []],
    // The position of each track. Its index in this array is the same the track's index in trackDetails.
    ["trackPositions", []],
    // The last track a unit placed down.
    ["lastTrackByUnit", createHashMap]
]];

_group addEventHandler ["Deleted", {
    params ["_group"];

    [_group] call vgm_g_fnc_tracking_stopRecordingTracks;
}];
