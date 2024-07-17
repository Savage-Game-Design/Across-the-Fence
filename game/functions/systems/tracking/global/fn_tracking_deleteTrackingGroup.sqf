/*
    File: fn_tracking_deleteTrackingGroup.sqf
    Author: Savage Game Design
    Date: 2024-03-09
    Last Update: 2024-03-18
    Public: Yes

    Description:
        Deletes a tracking group from the system, with all data.

    Parameter(s):
        _trackingGroupId - ID of the tracking group [STRING]

    Returns:
        Nothing

    Example(s):
        ["1"] call vgm_g_fnc_tracking_deleteTrackingGroup;
 */

params ["_trackingGroupId"];

vgm_l_tracking_trackingGroups deleteAt _trackingGroupId;
