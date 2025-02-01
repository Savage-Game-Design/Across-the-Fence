/*
    File: fn_virtsquad_createMissionSquadsInfo.sqf
    Author: Savage Game Design
    Date: 2025-01-16
    Last Update: 2025-01-16
    Public: No

    Description:
        Creates the per-mission data structure, for tracking squads.

    Parameter(s):
        None

    Returns:
        Mission squad details [HASHMAP]

    Example(s):
        [] call vgm_s_fnc_virtsquad_createMissionSquadsInfo;
 */

// Note - we could turn this into a deep copy (+) as an optimisation

createHashMapFromArray [
    // All squads on this mission, indexed by id
    ["squads", createHashMap],
    // All squads that aren't spawned in
    ["vSquadIndex", [{ _this get "pos" }] call vgm_g_fnc_posindex_create select 0],
    // All spawned squads, indexed by id
    ["spawnedSquads", createHashMap]
]
