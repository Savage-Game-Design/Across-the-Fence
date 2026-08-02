/*
    File: fn_voiceDetection_postInit.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-05
    Public: Yes

    Description:
        TFAR voice detection for AI awareness. When players speak via TFAR
        direct speech, nearby AI will investigate the sound source based on
        the player's voice volume setting mapped to detection radii.

        TFAR is a soft dependency - if the mod is not loaded, this system
        is completely skipped with no errors.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
*/

// Soft dependency: exit silently if TFAR is not loaded
if !(isClass (configFile >> "CfgPatches" >> "task_force_radio")) exitWith {};

// Throttle state
vgm_c_voiceDetection_lastEventTime = -4;
vgm_c_voiceDetection_speakStartTime = -1;
vgm_c_voiceDetection_speakHandlerId = nil;

[
    "vgm_mission_deploy_local",
    {
        params ["_publicMissionInfo"];

        if !(isNil "vgm_c_voiceDetection_speakHandlerId") exitWith {
            [format ["Attempting to setup voice detection on %1 twice", player]] call vgm_g_fnc_logWarning;
        };

        vgm_c_voiceDetection_locEventGroup = _publicMissionInfo get "id";

        // Listen for TFAR OnSpeak events
        // Params: 0: OBJECT (unit), 1: BOOLEAN (is speaking)
        ["vgm_voiceDetection", "OnSpeak", {
            params ["_unit", "_isSpeaking"];

            if (!_isSpeaking) exitWith {
                // Reset speak timer and throttle
                vgm_c_voiceDetection_speakStartTime = -1;
                vgm_c_voiceDetection_lastEventTime = -4;
            };

            // Track when speaking started
            if (vgm_c_voiceDetection_speakStartTime < 0) then {
                vgm_c_voiceDetection_speakStartTime = time;
            };

            // Must speak for 2 seconds before triggering detection
            if (time - vgm_c_voiceDetection_speakStartTime < 2) exitWith {};

            // Throttle: skip if last event was less than 4 seconds ago
            if (time - vgm_c_voiceDetection_lastEventTime < 4) exitWith {};
            vgm_c_voiceDetection_lastEventTime = time;

            // tf_voiceVolume: 0.0-1.0, maps to TF_max_voice_volume (default 60m)
            private _voiceVolume = _unit getVariable ["tf_voiceVolume", 0.6];
            private _radius = switch (true) do {
                case (_voiceVolume <= 0.2): { 8 };    // Whisper
                case (_voiceVolume <= 0.6): { 30 };   // Normal
                default                    { 100 };   // Loud / Yelling
            };

            [
                vgm_c_voiceDetection_locEventGroup,
                getPosASL player,
                _radius,
                "player_voice",
                [player]
            ] call vgm_g_fnc_locEvents_triggerEvent;
        }, player] call TFAR_fnc_addEventHandler;

        vgm_c_voiceDetection_speakHandlerId = "vgm_voiceDetection";
    }
] call para_g_fnc_event_subscribeLocal;

[
    "vgm_mission_end_local",
    {
        if (isNil "vgm_c_voiceDetection_speakHandlerId") exitWith {};

        ["vgm_voiceDetection", "OnSpeak", player] call TFAR_fnc_removeEventHandler;

        vgm_c_voiceDetection_speakHandlerId = nil;
        vgm_c_voiceDetection_locEventGroup = vgm_g_dangerReport_defaultLocEventGroup;
    }
] call para_g_fnc_event_subscribeLocal;
