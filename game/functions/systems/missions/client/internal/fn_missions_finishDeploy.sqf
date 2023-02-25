/*
    File: fn_missions_finishDeploy.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-04-24
    Public: No

    Description:
        Finishes the player deploying on their assigned mission.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        []  remoteExecCall ["vgm_c_fnc_missions_finishDeploy", _player];
 */

["Finalising mission deploy"] call vgm_g_fnc_logInfo;

private _missionsData = localNamespace getVariable "vgm_c_missions_data";
private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;

if (isNil "_currentMission") exitWith {};

private _defaultStartPosASL = _currentMission get "startPosASL";
private _safeStartPosASL = _defaultStartPosASL findEmptyPosition [1, 20, "CAManBase"];
private _startPosASL = [AGLtoASL _safeStartPosASL, _defaultStartPosASL] select (_safeStartPosASL isEqualTo []);

player setPosASL _startPosASL;

//- Unfades the screen
