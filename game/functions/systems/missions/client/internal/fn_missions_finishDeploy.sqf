/*
    File: fn_missions_finishDeploy.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2024-11-02
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

_this spawn {
    private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;

    if (isNil "_currentMission") exitWith {};
    waitUntil {scriptDone (missionNamespace getVariable ["vgm_c_missions_fadeEffectScript", scriptNull])};

    private _defaultStartPosASL = _currentMission get "startPosASL";
    private _safeStartPosASL = _defaultStartPosASL findEmptyPosition [1, 20, "CAManBase"];
    private _startPosASL = [AGLtoASL _safeStartPosASL, _defaultStartPosASL] select (_safeStartPosASL isEqualTo []);

    player setVehiclePosition [ASLToATL _startPosASL, [], 5, "NONE"];

    ["vgm_mission_deploy_local", _currentMission] call para_g_fnc_event_triggerLocal;

    // - Unfades the screen
    sleep 1;
    [1] spawn BIS_fnc_fadeEffect;
};
