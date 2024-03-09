/*
    File: fn_tracking_trackRecordingJob.sqf
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

{
    [_x] call vgm_g_fnc_tracking_recordTracks;
} forEach values vgm_l_tracking_trackingGroups;
