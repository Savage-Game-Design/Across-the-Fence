/*
    File: fn_mission_objects_deleteObject.sqf
    Author: Savage Game Design
    Date: 2023-12-20
    Last Update: 2024-10-25
    Public: Yes

    Description:
        Delete virtual object from the mission, object instance will be deleted on client machines.

    Parameter(s):
        _mission  - Mission ID or Mission to delete the object from [HASHMAP, NUMBER]
        _objectId - Id of the object to be deleted [STRING]

    Returns:
        Nothing

    Example(s):
        [_mission, "objectRandomId"] call vgm_s_fnc_mission_objects_deleteObject;
 */

params ["_mission", "_objectId"];

if (_mission isEqualType 0) then {
    _mission = [_mission] call vgm_s_fnc_missions_getById;
};

private _missionId = _mission get "public" get "id";
private _missionObjects = vgm_s_mission_objects_data getOrDefault [_missionId, createHashMap, true];

_missionObjects deleteAt _objectId;

// delete on all clients in mission and server
private _machines = values (_mission get "machineIds") + [2];
[_missionId, _objectId] remoteExecCall ["vgm_g_fnc_mission_objects_deleteObject", _machines];

nil
