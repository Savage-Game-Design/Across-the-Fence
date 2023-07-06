/*
    File: fn_missions_spawnMission.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-02-26
    Public: No

    Description:
        Spawns the entities involves with the mission, such as locations, oddities, objectives.

    Parameter(s):
        _mission - Mission to spawn [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_missions_spawnMission;
 */

params ["_mission"];

// Spawn in placeholder objective, and setup basic AI objectives
