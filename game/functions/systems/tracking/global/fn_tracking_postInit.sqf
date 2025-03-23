/*
    File: fn_tracking_postInit.sqf
    Author: Savage Game Design
    Date: 2024-03-08
    Last Update: 2024-03-18
    Public: No

    Description:
        Tracking system postInit

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
 */

// Records tracks every X seconds.
["trackingJob", { _this call vgm_g_fnc_tracking_trackRecordingJob }, [], vgm_g_tracking_trackRecordDelay] call para_g_fnc_scheduler_add_job;

["vgm_mission_started", {
    params ["_eventArgs"];
    _eventArgs params ["_missionId"];

    private _publicMissionInfo = [] call vgm_c_fnc_missions_getMissions get _missionId;

    // TODO - Add "isNil" check

    [_missionId, _publicMissionInfo get "group"] call vgm_g_fnc_tracking_startRecordingTracks;

}] call para_g_fnc_event_subscribeServer;
