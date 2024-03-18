/*
    File: fn_tracking_stopRecordingTracks.sqf
    Author: Savage Game Design
    Date: 2024-03-08
    Last Update: 2024-03-18
    Public: Yes

    Description:
        Stops recording tracks for the given Arma group, within a specific tracking group.

    Parameter(s):
        _trackingGroupId - ID of the tracking group to remove the group from [STRING]
        _groupHash - Group (or hashValue of group) to remove [GROUP/STRING]

    Returns:
        Nothing

    Example(s):
        ["1", group player] call vgm_g_fnc_tracking_stopRecordingTracks;
 */

params ["_trackingGroupId", "_groupHash"];

if (_groupHash isEqualType grpNull) then {
    _groupHash = hashValue _groupHash;
};

vgm_l_tracking_trackingGroups getOrDefault [_trackingGroupId, createHashMap] get "groups" deleteAt _groupHash;
