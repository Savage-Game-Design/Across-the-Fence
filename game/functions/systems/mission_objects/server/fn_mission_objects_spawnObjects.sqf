/*
    File: fn_mission_ojbect_spawnObjects.sqf
    Author: Savage Game Design
    Date: 2023-12-20
    Last Update: 2024-01-04
    Public: Yes

    Description:
        Spawn virtual objects on server and clients paricipating in the mission.

    Parameter(s):
        _mission        - Mission to spawn the objects in [HASHMAP]
        _missionObjects - Objects hashmap or array of object Ids [HASHMAP, STRING]

    Returns:
        Nothing

    Example(s):
        [_mission, _missionObjects] call vgm_s_fnc_mission_objects_spawnObjects
 */

params ["_mission", "_missionObjects"];
private _missionId = _mission get "public" get "id";

// turn object ids into a spawn "chunk"
if (_missionObjects isEqualType []) then {
    private _allMissionObjects = vgm_s_mission_objects_data getOrDefault [_missionId, createHashMap];
    _missionObjects = createHashMapFromArray (_missionObjects select {_x in _allMissionObjects} apply {[_x, _allMissionObjects get _x]});
};

format ["Sending %1 server objects for %2", count _missionObjects, _missionId] call vgm_g_fnc_logInfo;

// spawn on all clients in mission and server
private _machines = values (_mission get "machineIds") + [2];
[_missionId, _missionObjects] remoteExecCall ["vgm_g_fnc_mission_objects_spawnObjects", _machines];

nil
