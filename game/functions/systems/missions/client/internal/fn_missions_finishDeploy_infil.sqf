/*
    File: fn_missions_finishDeploy_infil.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-05
    Public: No

    Description:
        Client-side infil deploy finish. Waits for fade to complete, then unfades
        the screen while the player is inside the infil helicopter.
        Subscribes to the infilLanded event for the LZ notification.

    Parameter(s):
        _helicopter - The infil helicopter [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_helicopter] remoteExecCall ["vgm_c_fnc_missions_finishDeploy_infil", _player];
 */

params [["_helicopter", objNull]];

["Finalising infil deploy -- unfading in helicopter"] call vgm_g_fnc_logInfo;

[_helicopter] spawn {
    params ["_helicopter"];

    private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
    if (isNil "_currentMission") exitWith {};

    // Wait for the fade-to-black from startDeploy to finish
    waitUntil {scriptDone (missionNamespace getVariable ["vgm_c_missions_fadeEffectScript", scriptNull])};

    // Wait for helicopter object to sync from server
    private _timeout = diag_tickTime + 15;
    waitUntil {
        sleep 0.2;
        !isNull _helicopter || diag_tickTime > _timeout
    };

    // Fallback: try group variable if the passed reference didn't sync
    if (isNull _helicopter) then {
        _helicopter = (group player) getVariable ["vgm_missions_infil_helicopter", objNull];
    };

    if (isNull _helicopter) exitWith {
        "Infil: helicopter not synced to client in time" call vgm_g_fnc_logError;
    };

    // Small pause so the transition isn't jarring
    sleep 2;

    // Board the helicopter locally (moveInCargo requires the unit to be local,
    // which on a dedicated server means it must run on the player's client).
    // Retry in a loop because moveInCargo silently fails when multiple clients
    // race for the same cargo seat at the same time.
    private _boardTimeout = diag_tickTime + 10;
    waitUntil {
        player moveInCargo _helicopter;
        sleep 0.5;
        vehicle player == _helicopter || diag_tickTime > _boardTimeout
    };

    if (vehicle player != _helicopter) then {
        format ["Infil: %1 failed to board helicopter after retries", name player] call vgm_g_fnc_logError;
    };

    // Subscribe to landed notification (server fires via triggerTargets)
    private _ehId = ["vgm_missions_gameplay_infilLanded", {
        hintSilent localize "STR_VGM_MISSIONS_INFIL_LZ_REACHED";
        playSoundUI ["3DEN_notificationDefault", 0.5];
    }] call para_g_fnc_event_subscribe;
    player setVariable ["vgm_missions_infil_landedEh", _ehId];

    // Subscribe to deployed event -- fire the local deploy event (skills, tutorials, etc.)
    private _deployEhId = ["vgm_missions_gameplay_infilDeployed", {
        private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
        if (!isNil "_currentMission") then {
            ["vgm_mission_deploy_local", _currentMission] call para_g_fnc_event_triggerLocal;
        };

        // Clean up this one-shot handler
        [player getVariable ["vgm_missions_infil_deployedEh", -1]] call para_g_fnc_event_unsubscribe;

        // Also clean up the landed handler
        [player getVariable ["vgm_missions_infil_landedEh", -1]] call para_g_fnc_event_unsubscribe;
    }] call para_g_fnc_event_subscribe;
    player setVariable ["vgm_missions_infil_deployedEh", _deployEhId];

    // Unfade -- player sees they are inside the helicopter
    sleep 1;
    [1] spawn BIS_fnc_fadeEffect;
};
