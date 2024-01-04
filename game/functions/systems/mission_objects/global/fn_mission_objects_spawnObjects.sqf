/*
    File: fn_spawnObjects.sqf
    Author: Savage Game Design
    Date: 2023-12-20
    Last Update: 2024-01-04
    Public: No

    Description:
        Create "real" instances of virtual mission objects.

    Parameter(s):
        _missionObjects - Mission objects [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_missionObjects] call vgm_c_fnc_mission_objects_spawnObjects
 */

params ["_missionId", "_missionObjects"];

if (remoteExecutedOwner != 2) then {
    format ["Mission object creation should be called from server to prevent object desync, expected 2 got %1", remoteExecutedOwner] call vgm_g_fnc_logWarning;
};

format ["Spawning %1 local mission objects for %2", count _missionObjects, _missionId] call vgm_g_fnc_logInfo;

private _localObjectsData = vgm_g_mission_objects getOrDefault [_missionId, createHashMap, true];

{
    private _id  = _x;
    if (_id in _localObjectsData) then {continue};
    _y params ["_class", "_position", "_dir", "_fnc_init", "_initParams"];

    private _object = createSimpleObject [_class, _position, true];
    _object setDir _dir;

    [_object, _initParams] call _fnc_init;

    _object setVariable ["vgm_mission_objects_id", _id];
    _localObjectsData set [_id, _object];
} forEach _missionObjects;
