/*
    File: fn_missions_gameplay_hatchet_postInit.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Server postInit for the Hatchet Force mission gameplay system.
        Subscribes to mission lifecycle events.
 */

if (!isServer) exitWith {};

["vgm_mission_available", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_hatchet_registerMission;
}] call para_g_fnc_event_subscribeServer;

["vgm_mission_started", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_hatchet_onMissionStarted;
}] call para_g_fnc_event_subscribeServer;

["vgm_mission_ended", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_missions_gameplay_hatchet_onMissionEnded;
}] call para_g_fnc_event_subscribeServer;

// Voice line event subscriptions (no RTO required — recon team has their own radio)
["vgm_voice_hatchet_briefing", {
    ["hatchet", "briefing", false, objNull, true] call vgm_s_fnc_voicelines_play;
}] call para_g_fnc_event_subscribeServer;

["vgm_voice_hatchet_insertionHot", {
    ["hatchet", "insertion_hot", false, objNull, true] call vgm_s_fnc_voicelines_play;
}] call para_g_fnc_event_subscribeServer;

["vgm_voice_hatchet_insertionCold", {
    ["hatchet", "insertion_cold", false, objNull, true] call vgm_s_fnc_voicelines_play;
}] call para_g_fnc_event_subscribeServer;

["vgm_voice_hatchet_teamContact", {
    (_this#0) params ["_missionId"];
    private _hatchetNetmap = [_missionId, "hatchet"] call vgm_s_fnc_missions_getSystemNetmap;
    private _reconTeam = if (!isNil "_hatchetNetmap") then {_hatchetNetmap getOrDefault ["reconTeam", []]} else {[]};
    private _speaker = objNull;
    {if (alive _x) exitWith {_speaker = _x}} forEach _reconTeam;
    ["hatchet", "team_contact", false, _speaker, true] call vgm_s_fnc_voicelines_play;
}] call para_g_fnc_event_subscribeServer;

["vgm_voice_hatchet_teamCasualty", {
    (_this#0) params ["_missionId"];
    private _hatchetNetmap = [_missionId, "hatchet"] call vgm_s_fnc_missions_getSystemNetmap;
    private _reconTeam = if (!isNil "_hatchetNetmap") then {_hatchetNetmap getOrDefault ["reconTeam", []]} else {[]};
    private _speaker = objNull;
    {if (alive _x) exitWith {_speaker = _x}} forEach _reconTeam;
    ["hatchet", "team_casualty", false, _speaker, true] call vgm_s_fnc_voicelines_play;
}] call para_g_fnc_event_subscribeServer;

["vgm_voice_hatchet_firstBirdInbound", {
    ["hatchet", "first_bird_inbound", false, objNull, true] call vgm_s_fnc_voicelines_play;
}] call para_g_fnc_event_subscribeServer;

["vgm_voice_hatchet_playerBirdInbound", {
    ["hatchet", "player_bird_inbound", false, objNull, true] call vgm_s_fnc_voicelines_play;
}] call para_g_fnc_event_subscribeServer;

// "you guys sure know how to throw a party" — plays when player extraction bird lifts off
["vgm_voice_hatchet_playerBirdAway", {
    [2, "hatchet", "player_bird_away", false, objNull, true] call vgm_s_fnc_voicelines_playDelayed;
}] call para_g_fnc_event_subscribeServer;
