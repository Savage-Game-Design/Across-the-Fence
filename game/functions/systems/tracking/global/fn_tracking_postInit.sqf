/*
    File: fn_tracking_preInit.sqf
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

// Records tracks every X seconds.
["trackingJob", { _this call vgm_g_fnc_tracking_trackRecordingJob }, [], 3] call para_g_fnc_scheduler_add_job;















