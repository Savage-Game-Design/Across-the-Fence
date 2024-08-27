/*
    File: fn_missions_finishDeploy.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2024-08-24
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

    // Adds tracker system event handlers
    // TODO: Remove when switching to main AI system
    player setVariable [
        "vgm_c_trackerFiredHandler",
        player addEventHandler ["Fired", {_this call vn_ms_fnc_tracker_onPlayerFired}]
    ];

    [] call vn_ms_fnc_tracker_tracksLoop;

    ["vgm_mission_deploy_local", _currentMission] call para_g_fnc_event_triggerLocal;

    // zoom map on the mission area
    [] call vgm_c_fnc_missions_coverMap;
    vgm_missions_zoomOnMapScript = (_currentMission get "targetZone") spawn {
        [_this] call vgm_g_fnc_loc_getTargetBoxBounds params ["_pos", "_size"];
        waitUntil {visibleMap}; // can't animate hidden map
        [
            _size vectorMultiply 2.5,
            _pos,
            0
        ] call BIS_fnc_zoomOnArea;
    };

    // - Unfades the screen
    sleep 1;
    [1] spawn BIS_fnc_fadeEffect;
};
