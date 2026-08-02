/*
    File: fn_missions_gameplay_snatch_postInit.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Server postInit for the Prisoner Snatch mission gameplay system.
        Subscribes to mission lifecycle events.
 */

if (!isServer) exitWith {};

["vgm_mission_available", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_snatch_registerMission;
}] call para_g_fnc_event_subscribeServer;

["vgm_mission_started", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_snatch_onMissionStarted;
}] call para_g_fnc_event_subscribeServer;

["vgm_mission_ended", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_snatch_onMissionEnded;
}] call para_g_fnc_event_subscribeServer;

// Voice line event subscriptions
["vgm_voice_snatch_briefing", {
    ["snatch", "briefing", true, objNull, true] call vgm_s_fnc_voicelines_play;
}] call para_g_fnc_event_subscribeServer;

// target_down sequence: COLUMBIA "We have a BICYCLE" → COVEY "confirm?" → COLUMBIA "That's a Roger"
["vgm_voice_snatch_targetDown", {
    (_this#0) params ["_missionId"];
    private _mission = [_missionId] call vgm_s_fnc_missions_getById;
    private _speaker = if (!isNil "_mission") then {leader (_mission get "public" get "group")} else {objNull};
    ["snatch", "target_down", true, _speaker, true] call vgm_s_fnc_voicelines_play;
    [2, "snatch", "target_down_confirm", true, objNull, true] call vgm_s_fnc_voicelines_playDelayed;
    [4, "snatch", "target_down_ack", true, _speaker, true] call vgm_s_fnc_voicelines_playDelayed;
}] call para_g_fnc_event_subscribeServer;

// extracting sequence: "stop eyeing up our prize" → "is that guy a General?" → "Negative he's a colonel"
["vgm_voice_snatch_extracting", {
    ["snatch", "extracting", false, objNull, true] call vgm_s_fnc_voicelines_play;
    [2, "snatch", "extracting_banter_1", false, objNull, true] call vgm_s_fnc_voicelines_playDelayed;
    [4, "snatch", "extracting_banter_2", false, objNull, true] call vgm_s_fnc_voicelines_playDelayed;
}] call para_g_fnc_event_subscribeServer;
