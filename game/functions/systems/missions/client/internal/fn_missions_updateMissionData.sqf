/*
    File: fn_missions_updateMissionData.sqf
    Author: Savage Game Design
    Date: 2023-04-23
    Last Update: 2023-04-23
    Public: No

    Description:
        Updates data for the given mission

    Parameter(s):
        _missionId - ID of the mission to update [NUMBER]
        _mission - Mission data [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_mission get "id", _mission] remoteExecCall ["vgm_c_fnc_missions_updateMissionData"]
 */

params ["_missionId", "_newMissionData"];

private _missionsData = localNamespace getVariable "vgm_c_missions_data";
private _currentMissionData = _missionsData get "missions" getOrDefault [_missionId, createHashMap, true];

// Guarantees that any references to the mission will be updated.
// Any references to any members are replaced, so references to them shouldn't be kept around in other systems.
_currentMissionData merge [_newMissionData, true];


