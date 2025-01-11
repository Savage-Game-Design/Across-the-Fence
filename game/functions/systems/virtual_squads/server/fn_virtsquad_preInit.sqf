/*
    File: fn_virtgroup_preInit.sqf
    Author:
    Date: 2025-01-09
    Last Update: 2025-01-11
    Public: No

    Description:
        PreInit for virtual groups
    */

vgm_s_virtsquad_spawnRange = 500;
vgm_s_virtsquad_despawnRange = 700;

vgm_s_virtsquad_nextId = 0;
// All squads registered with the system.
vgm_s_virtsquad_squads = createHashMap;
// Position index for unspawned / virtualised squads only.
vgm_s_virtsquad_vSquadIndex = [{ _this get "pos" }] call vgm_g_fnc_posindex_create select 0;
// Spawned groups
vgm_s_virtsquad_spawnedSquads = createHashMap;

// Both queues are used in splitting work across multiple frames.
vgm_s_virtsquad_playerQueue = [];
vgm_s_virtsquad_spawnedSquadQueue = [];
vgm_s_virtsquad_spawnQueue = createHashMap;
vgm_s_virtsquad_despawnQueue = createHashMap;
