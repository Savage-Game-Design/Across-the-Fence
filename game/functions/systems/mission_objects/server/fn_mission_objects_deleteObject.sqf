/*
    File: fn_mission_objects_deleteObject.sqf
    Author: Savage Game Design
    Date: 2023-12-20
    Last Update: 2023-12-20
    Public: Yes

    Description:
        Delete virtual object from the mission, object instance will be deleted on client machines.

    Parameter(s):
        _mission  - Mission ID or Mission to delete the object from [HASHMAP, STRING]
        _objectId - Id of the object to be deleted [STRING]

    Returns:
        Nothing

    Example(s):
        [_mission, "objectRandomId"] call vgm_s_fnc_mission_objects_deleteObject;
 */

params ["_mission", "_objectId"];

if (_mission isEqualType "") then {
    _mission = [_mission] call vgm_s_fnc_missions_getById;
};

private _missionObjects = vgm_s_mission_objects_data getOrDefault [(_mission get "public" get "id"), createHashMap, true];

_missionObjects deleteAt _objectId;

[_objectId] remoteExecCall ["vgm_c_fnc_mission_objects_deleteObject", values (_mission get "machineIds")];

nil
