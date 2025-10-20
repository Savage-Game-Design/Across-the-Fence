/*
    File: fn_zombie_ambientNoise.sqf
    Author: Savage Game Design
    Date: 2025-10-24
    Last Update: 2025-10-29
    Public: No

    Description:
        Plays an ambient noise of a given type, and adds a delay before it can be triggered again

    Parameter(s):
        _zombie - Unit to play sound from [UNIT]
        _soundType - Type of sound to play (from vgm_l_zombie_sounds) [STRING]
        _delayRange - Delay is selected as a random time between these values [ARRAY]

    Returns:
        Nothing

    Example(s):
        [cursorObject, "moan", [10, 30]] call vgm_g_fnc_zombie_ambientNoise;
 */

params ["_zombie", "_soundType", "_delayRange"];

private _nextSounds = _zombie getVariable "vgm_l_zombie_nextSoundPossible";

if (time < _nextSounds getOrDefault [_soundType, 0]) exitWith {};

private _allSounds = _zombie getVariable "vgm_l_zombie_sounds";
private _sound = selectRandom (_allSounds getOrDefault [_soundType, []]);

if (isNil "_sound") exitWith {};

_nextSounds set [_soundType, time + ((_delayRange # 0) + random (_delayRange # 1))];
[_zombie, _sound, 1] call vgm_g_fnc_zombie_makeNoise;
