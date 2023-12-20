/*
    File: fn_spawnObjects.sqf
    Author: Savage Game Design
    Date: 2023-12-20
    Last Update: 2023-12-20
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_c_fnc_mission_objects_spawnObjects
 */

params ["_missionObjects"];

format ["Spawning %1 local mission objects", count _missionObjects] call vgm_g_fnc_logInfo;

{
    private _id  = _x;
    if (_id in vgm_c_mission_objects) then {continue};
    _y params ["_class", "_position", "_dir", "_fnc_init", "_initParams"];

    private _object = createVehicleLocal [_class, _position, [], 0, "CAN_COLLIDE"];
    _object setDir _dir;

    [_object, _initParams] call _fnc_init;

    _object setVariable ["vgm_mission_objects_id", _id];
    vgm_c_mission_objects set [_id, _object];
} forEach _missionObjects;
