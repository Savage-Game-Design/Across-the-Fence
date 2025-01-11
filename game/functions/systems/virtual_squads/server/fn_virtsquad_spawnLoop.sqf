/*
    File: fn_virtsquad_spawnLoop.sqf
    Author: Savage Game Design
    Date: 2025-01-11
    Last Update: 2025-01-11
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

{
    [_y] call vgm_s_fnc_virtsquad_despawn;
    vgm_s_virtsquad_despawnQueue deleteAt _x;
} forEach vgm_s_virtsquad_despawnQueue;

{
    [_y] call vgm_s_fnc_virtsquad_spawn;
    vgm_s_virtsquad_spawnQueue deleteAt _x;
} forEach vgm_s_virtsquad_spawnQueue;
