/*
    File: fn_missions_finishDeploy.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-09-21
    Public: No

    Description:
        Finishes the player deploying on their assigned mission.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] remoteExecCall ["vgm_c_fnc_missions_finishDeploy", _player];
 */

["Finalising mission deploy"] call vgm_g_fnc_logInfo;

private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;

if (isNil "_currentMission") exitWith {};

private _defaultStartPosASL = _currentMission get "startPosASL";
private _safeStartPosASL = _defaultStartPosASL findEmptyPosition [1, 20, "CAManBase"];
private _startPosASL = [AGLtoASL _safeStartPosASL, _defaultStartPosASL] select (_safeStartPosASL isEqualTo []);

player setPosASL _startPosASL;

// Adds tracker system event handlers
// TODO: Remove when switching to main AI system
player setVariable [
    "vgm_c_trackerFiredHandler",
    player addEventHandler ["Fired", {_this call vn_ms_fnc_tracker_onPlayerFired}]
];

[] call vn_ms_fnc_tracker_tracksLoop;

//- Unfades the screen

["vgm_mission_deploy_local", _currentMission] call para_g_fnc_event_triggerLocal;
