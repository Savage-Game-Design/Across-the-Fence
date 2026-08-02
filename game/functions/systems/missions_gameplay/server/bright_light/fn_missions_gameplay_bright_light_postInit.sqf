/*
    File: fn_missions_gameplay_bright_light_postInit.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Server postInit for the Bright Light Rescue mission gameplay system.
        Subscribes to mission lifecycle events.
 */

if (!isServer) exitWith {};

["vgm_mission_available", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_bright_light_registerMission;
}] call para_g_fnc_event_subscribeServer;

["vgm_mission_started", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_bright_light_onMissionStarted;
}] call para_g_fnc_event_subscribeServer;

["vgm_mission_ended", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_bright_light_onMissionEnded;
}] call para_g_fnc_event_subscribeServer;

// Intel gathered event (Variant B hold action callback)
["vgm_bright_light_intelGathered", {
    (_this#0) params ["_missionId"];
    private _blNetmap = [_missionId, "bright_light"] call vgm_s_fnc_missions_getSystemNetmap;
    if (isNil "_blNetmap") exitWith {};
    [_blNetmap, "intelGathered", true] call para_s_fnc_netmap_set;
    format ["Bright Light: Intel gathered for mission %1", _missionId] call vgm_g_fnc_logInfo;
}] call para_g_fnc_event_subscribeServer;

// Voice line event subscriptions

// In helicopter: briefing → approach (when close to LZ)
["vgm_voice_bright_light_briefing", {
    ["bright_light", "briefing", true, objNull, true] call vgm_s_fnc_voicelines_play;
}] call para_g_fnc_event_subscribeServer;

["vgm_voice_bright_light_approach", {
    ["bright_light", "approach", true, objNull, true] call vgm_s_fnc_voicelines_play;
}] call para_g_fnc_event_subscribeServer;

// After landing: COLUMBIA moving out → COVEY response
["vgm_voice_bright_light_landed", {
    (_this#0) params ["_missionId"];
    private _mission = [_missionId] call vgm_s_fnc_missions_getById;
    private _speaker = if (!isNil "_mission") then {leader (_mission get "public" get "group")} else {objNull};
    ["bright_light", "moving_out", true, _speaker, true] call vgm_s_fnc_voicelines_play;
    [3, "bright_light", "moving_out_response", true, objNull, true] call vgm_s_fnc_voicelines_playDelayed;
}] call para_g_fnc_event_subscribeServer;

// Reaching crash site: COLUMBIA secure → COLUMBIA KIA report → COVEY response
["vgm_voice_bright_light_crashSecure", {
    (_this#0) params ["_missionId"];
    private _mission = [_missionId] call vgm_s_fnc_missions_getById;
    private _speaker = if (!isNil "_mission") then {leader (_mission get "public" get "group")} else {objNull};
    ["bright_light", "crash_secure", true, _speaker, true] call vgm_s_fnc_voicelines_play;
    [4, "bright_light", "crash_report", true, _speaker, true] call vgm_s_fnc_voicelines_playDelayed;
    [10, "bright_light", "crash_report_response", true, objNull, true] call vgm_s_fnc_voicelines_playDelayed;
}] call para_g_fnc_event_subscribeServer;

// Finding the pilot: COLUMBIA package 2 secured → COVEY enemy converging warning
["vgm_voice_bright_light_targetPickedUp", {
    (_this#0) params ["_missionId"];
    private _mission = [_missionId] call vgm_s_fnc_missions_getById;
    private _speaker = if (!isNil "_mission") then {leader (_mission get "public" get "group")} else {objNull};
    ["bright_light", "target_picked_up", true, _speaker, true] call vgm_s_fnc_voicelines_play;
    [4, "bright_light", "target_picked_up_response", true, objNull, true] call vgm_s_fnc_voicelines_playDelayed;
}] call para_g_fnc_event_subscribeServer;
