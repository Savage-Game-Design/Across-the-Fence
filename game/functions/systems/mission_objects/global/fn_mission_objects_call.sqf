/*
    File: fn_mission_objects_call.sqf
    Author: Savage Game Design
    Date: 2024-12-16
    Last Update: 2025-08-23
    Public: No

    Description:
        Execute given code on local instances of the objects.

    Parameter(s):
        _missionId - Id of the mission [NUMBER]
        _objectIds - Ids of the objects to execute code on [ARRAY]
        _fnc_callback - Code to execute, where objects are local [CODE]

    Returns:
        Nothing

    Example(s):
        [1, "objectId123", {hint str _this}] call vgm_g_fnc_mission_objects_call
 */

params [
    "_missionId",
    "_objectIds",
    ["_callback", [[], {}], [{}, []], 2]
];

if (remoteExecutedOwner != 2) exitWith {
    format ["Mission object call should be called from server to prevent object desync, expected 2 got %1", remoteExecutedOwner] call vgm_g_fnc_logWarning;
};

if (_callback isEqualType {}) then {
    _callback = [[], _callback];
};

_callback params ["_callbackParams", "_fnc_callback"];

format ["Call on %1 local mission objects for %2", count _objectIds, _missionId] call vgm_g_fnc_logInfo;

private _localObjectsData = vgm_g_mission_objects getOrDefault [_missionId, createHashMap, true];

{
    private _id  = _x;
    if !(_id in _localObjectsData) then {continue};
    private _object = _localObjectsData get _id;

    [_object, _callbackParams] call _fnc_callback;

} forEach _objectIds;
