/*
    File: fn_virtgroup_postInit.sqf
    Author:
    Date: 2025-01-09
    Last Update: 2025-01-11
    Public: No

    Description:
        PostInit for virtual groups
    */

addMissionEventHandler ["EachFrame", { call vgm_s_fnc_virtsquad_perFrame }];

[
    "vgm_virtsquad_spawnLoop",
    { call vgm_s_fnc_virtsquad_spawnLoop },
    [],
    2
] call para_g_fnc_scheduler_add_job;
