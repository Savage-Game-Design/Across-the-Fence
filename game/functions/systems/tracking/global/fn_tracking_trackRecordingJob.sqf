/*
    File: fn_tracking_trackRecordingJob.sqf
    Author: Savage Game Design
    Date: 2024-03-08
    Last Update: 2024-03-18
    Public: No

    Description:
        Records tracks for all tracking groups.

        Should be called periodically to record tracks.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        ["trackingJob", vgm_g_fnc_tracking_trackRecordingJob, [], vgm_g_tracking_trackRecordDelay] call para_g_fnc_scheduler_add_job;
 */

{
    [_x] call vgm_g_fnc_tracking_recordTracks;
} forEach values vgm_l_tracking_trackingGroups;
