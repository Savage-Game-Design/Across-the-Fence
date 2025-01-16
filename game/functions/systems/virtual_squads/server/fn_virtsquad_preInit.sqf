#include "script_component.inc"
/*
    File: fn_virtgroup_preInit.sqf
    Author:
    Date: 2025-01-09
    Last Update: 2025-01-16
    Public: No

    Description:
        PreInit for virtual groups
    */

vgm_s_virtsquad_spawnRange = 500;
vgm_s_virtsquad_despawnRange = 700;

vgm_s_virtsquad_nextId = 0;
// Maps mission ID to a hashmap with a vSquadIndex and a hashmap of spawned squads.
vgm_s_virtsquad_perMissionSquadsInfo = createHashMap;
vgm_s_virtsquad_perMissionSquadsInfo set [
    // Global mission is used for any squads not explicitly assigned to a mission
    GLOBAL_MISSION_ID, [] call vgm_s_fnc_virtsquad_createMissionSquadsInfo
];

// Both queues are used in splitting work across multiple frames.
vgm_s_virtsquad_playerQueue = [];
vgm_s_virtsquad_spawnedSquadQueue = [];
vgm_s_virtsquad_spawnQueue = createHashMap;
vgm_s_virtsquad_despawnQueue = createHashMap;
