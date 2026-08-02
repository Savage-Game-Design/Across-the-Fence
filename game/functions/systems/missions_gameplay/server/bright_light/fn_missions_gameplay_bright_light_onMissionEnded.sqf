/*
    File: fn_missions_gameplay_bright_light_onMissionEnded.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Handles cleanup when a Bright Light mission ends.
        Deletes crash scene objects, restores hidden terrain, removes timer UI.

    Parameter(s):
        _missionId - Id of the mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_missionId] call vgm_s_fnc_missions_gameplay_bright_light_onMissionEnded
 */

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {};

private _missionType = (_mission get "parameters") getOrDefault ["missionType", "scouting"];
if (_missionType != "bright_light") exitWith {};

private _missionPublic = _mission get "public";
private _playerGroup = _missionPublic get "group";

private _blNetmap = [_missionId, "bright_light"] call vgm_s_fnc_missions_getSystemNetmap;
if (isNil "_blNetmap") exitWith {};

// Delete target
private _target = _blNetmap get "target";
if (!isNil "_target" && {!isNull _target}) then {
    deleteVehicle _target;
};

// Delete wreck
private _wreck = _blNetmap get "wreck";
if (!isNil "_wreck" && {!isNull _wreck}) then {
    deleteVehicle _wreck;
};

// Delete spawned enemies
private _spawnedUnits = _blNetmap getOrDefault ["spawnedUnits", []];
{
    if (!isNull _x) then {deleteVehicle _x};
} forEach _spawnedUnits;

// Delete crash scene objects (crater, fires, smoke, dead body, intel object)
private _sceneObjects = _blNetmap getOrDefault ["sceneObjects", []];
{
    if (!isNull _x) then {deleteVehicle _x};
} forEach _sceneObjects;

// Restore hidden terrain objects
private _hiddenTerrainObjects = _blNetmap getOrDefault ["hiddenTerrainObjects", []];
{
    _x hideObjectGlobal false;
} forEach _hiddenTerrainObjects;

// Remove timer UI on all clients
[0, false] remoteExec ["vgm_c_fnc_missions_gameplay_bright_light_timerDisplay", _playerGroup];

// Mark incomplete subtasks as FAILED before cleanup
private _targetExtracted = _blNetmap getOrDefault ["targetExtracted", false];
if (!_targetExtracted) then {
    private _parentTaskId = format ["vgm_bright_light_%1", _missionId];
    private _pilotVariant = _blNetmap getOrDefault ["pilotVariant", ""];

    [format ["%1_locate", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
    if (_pilotVariant == "pilot_captured") then {
        [format ["%1_gatherIntel", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
        [format ["%1_rescue", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
    } else {
        [format ["%1_secure", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
    };
    [format ["%1_extract", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
    [_parentTaskId, "FAILED"] call BIS_fnc_taskSetState;
    format ["Bright Light: Target not extracted for mission %1 — objective failed", _missionId] call vgm_g_fnc_logInfo;
};

[
    format ["vgm_bright_light_%1", _missionId],
    true,
    true
] call BIS_fnc_deleteTask;

format ["Bright Light: Cleaned up mission %1", _missionId] call vgm_g_fnc_logInfo;
