/*
    File: fn_director_getDirectorForMissionId.sqf
    Author: Savage Game Design
    Date: 2025-01-16
    Last Update: 2025-01-16
    Public: No

    Description:
        Gets the director for the mission with the given id.

    Parameter(s):
        _missionId - ID of the mission [NUMBER]

    Returns:
        Director or nil [HASHMAP]

    Example(s):
        [_group getVariable "vgm_g_missionId"] call vgm_s_fnc_director_getDirectorForMissionId;
 */

params ["_missionId"];

[_missionId] call vgm_s_fnc_missions_getById get "director"

