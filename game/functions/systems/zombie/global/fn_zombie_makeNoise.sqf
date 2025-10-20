/*
    File: fn_zombie_makeNoise.sqf
    Author: Savage Game Design
    Date: 2025-10-22
    Last Update: 2025-10-29
    Public: No

    Description:
        Makes the zombie play a sound from its position.

    Parameter(s):
        _zombie - Unit to play sound from [UNIT]
        _soundFile - File to play [STRING]
        _volume - Volume to play file at [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_zombie, "\ryanzombies\sounds\moaning1.ogg", 1] call vgm_g_fnc_zombie_makeNoise;
 */

params ["_zombie", "_soundFile", "_volume"];

// TODO - Switch to say3D, but CfgSounds needs all off Ryan's sounds re-adding with the right volume...
playSound3D [_soundFile, _zombie, false, getPosASL _zombie, 1, 1, 100]


