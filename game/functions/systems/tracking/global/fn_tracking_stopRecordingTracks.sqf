/*
    File: fn_tracking_stopRecordingTracks.sqf
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

params ["_trackingGroupId", "_groupHash"];

if (_groupHash isEqualType grpNull) then {
    _groupHash = hashValue _groupHash;
};

vgm_l_tracking_trackingGroups getOrDefault [_trackingGroupId, createHashMap] get "groups" deleteAt _groupHash;
