/*
    File: fn_virtsquad_spawnLoop.sqf
    Author: Savage Game Design
    Date: 2025-01-11
    Last Update: 2025-01-16
    Public: No

    Description:
        Monitors the spawn and despawn queues, and handles any work to be done.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_virtsquad_spawnLoop;
 */

// Loop through 'values' array of the HashMap, so that the deleteAt doesn't affect the iteration (due to it being a copy)
{
    [_x] call vgm_s_fnc_virtsquad_despawn;
    vgm_s_virtsquad_despawnQueue deleteAt (_x get "id");
} forEach values vgm_s_virtsquad_despawnQueue;

// Loop through 'values' array of the HashMap, so that the deleteAt doesn't affect the iteration (due to it being a copy)
{
    [_x] call vgm_s_fnc_virtsquad_spawn;
    vgm_s_virtsquad_spawnQueue deleteAt (_x get "id");
} forEach values vgm_s_virtsquad_spawnQueue;
