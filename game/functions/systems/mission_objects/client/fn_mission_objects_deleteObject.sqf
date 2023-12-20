/*
    File: fn_mission_objects_deleteObject.sqf
    Author: Savage Game Design
    Date: 2023-12-20
    Last Update: 2023-12-20
    Public: No

    Description:
        Remove local instance of mission object with given id.

    Parameter(s):
        _objectId - Id of the object to delete [STRING]

    Returns:
        Nothing

    Example(s):
        [cursorObject getVariable ["vgm_mission_objects_id", ""]] call vgm_c_fnc_mission_objects_deleteObject
 */

params ["_objectId"];

if (remoteExecutedOwner != 2) then {
    format ["Mission object removal should be called from server to prevent object desync, expected 2 got %1 for %2", remoteExecutedOwner, _objectId] call vgm_g_fnc_logWarning;
};

format ["Deleting local object: %1", _objectId] call vgm_g_fnc_logInfo;

deleteVehicle (vgm_c_mission_objects getOrDefault [_objectId, objNull]);
vgm_c_mission_objects deleteAt _objectId;

nil
