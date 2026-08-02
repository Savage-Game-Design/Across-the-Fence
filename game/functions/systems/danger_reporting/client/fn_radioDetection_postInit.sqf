/*
    File: fn_radioDetection_postInit.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: Yes

    Description:
        TFAR radio interception for Mission Director alertness. When a player
        holds PTT (SW or LR) for more than 5 seconds, PAVN intercepts the
        signal and the Mission Director gains +6 alertness. This simulates
        the time it takes for NVA radio direction-finding to locate the
        transmission source.

        Throttled to one intercept event per 30 seconds to prevent PTT spam
        from instantly maxing out the director.

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

// State
vgm_c_radioDetection_tangentStartTime = -1;
vgm_c_radioDetection_lastInterceptTime = -30;
vgm_c_radioDetection_tangentHandlerId = nil;
vgm_c_radioDetection_checkHandle = -1;

[
    "vgm_mission_deploy_local",
    {
        params ["_publicMissionInfo"];

        if !(isNil "vgm_c_radioDetection_tangentHandlerId") exitWith {
            [format ["Attempting to setup radio detection on %1 twice", player]] call vgm_g_fnc_logWarning;
        };

        private _missionId = _publicMissionInfo get "id";
        vgm_c_radioDetection_missionId = _missionId;

        // Listen for TFAR OnTangent events
        // Params: 0: OBJECT (unit), 1: STRING (active radio ID), 2: NUMBER (tangent type)
        // Tangent types: 0=SW down, 1=SW up, 2=LR down, 3=LR up, 4=DD down, 5=DD up
        ["vgm_radioDetection", "OnTangent", {
            params ["_unit", "_radio", "_tangentType"];

            // Only care about SW (0,1) and LR (2,3), not intercom/DD (4,5)
            if (_tangentType >= 4) exitWith {};

            // Even = PTT pressed (down), odd = PTT released (up)
            private _isTransmitting = (_tangentType % 2 == 0);

            if (_isTransmitting) then {
                // PTT pressed — record start time
                vgm_c_radioDetection_tangentStartTime = time;

                // Start a per-frame check for the 5-second threshold
                vgm_c_radioDetection_checkHandle = [{
                    // Still transmitting and held for 5+ seconds?
                    if (vgm_c_radioDetection_tangentStartTime < 0) exitWith {
                        [_this select 1] call CBA_fnc_removePerFrameHandler;
                    };

                    private _elapsed = time - vgm_c_radioDetection_tangentStartTime;
                    if (_elapsed >= 5) then {
                        // Throttle: only one intercept per 30 seconds
                        if (time - vgm_c_radioDetection_lastInterceptTime >= 30) then {
                            vgm_c_radioDetection_lastInterceptTime = time;
                            [vgm_c_radioDetection_missionId] remoteExecCall ["vgm_s_fnc_director_onRadioTransmission", 2];
                        };

                        // Stop checking — we've triggered (or were throttled)
                        vgm_c_radioDetection_tangentStartTime = -1;
                        [_this select 1] call CBA_fnc_removePerFrameHandler;
                    };
                }, 1] call CBA_fnc_addPerFrameHandler;
            } else {
                // PTT released — cancel if under 5 seconds
                vgm_c_radioDetection_tangentStartTime = -1;
                if (vgm_c_radioDetection_checkHandle >= 0) then {
                    [vgm_c_radioDetection_checkHandle] call CBA_fnc_removePerFrameHandler;
                    vgm_c_radioDetection_checkHandle = -1;
                };
            };
        }, player] call TFAR_fnc_addEventHandler;

        vgm_c_radioDetection_tangentHandlerId = "vgm_radioDetection";
    }
] call para_g_fnc_event_subscribeLocal;

[
    "vgm_mission_end_local",
    {
        if (isNil "vgm_c_radioDetection_tangentHandlerId") exitWith {};

        ["vgm_radioDetection", "OnTangent", player] call TFAR_fnc_removeEventHandler;

        // Clean up any pending check
        if (vgm_c_radioDetection_checkHandle >= 0) then {
            [vgm_c_radioDetection_checkHandle] call CBA_fnc_removePerFrameHandler;
            vgm_c_radioDetection_checkHandle = -1;
        };

        vgm_c_radioDetection_tangentHandlerId = nil;
        vgm_c_radioDetection_tangentStartTime = -1;
    }
] call para_g_fnc_event_subscribeLocal;
