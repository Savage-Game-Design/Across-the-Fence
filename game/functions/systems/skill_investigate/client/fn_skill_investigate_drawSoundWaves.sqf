#include "script_component.inc"
/*
    File: fn_skill_investigate_drawSoundWaves.sqf
    Author: Savage Game Design
    Date: 2024-01-22
    Last Update: 2024-02-10
    Public: No

    Description:
        Draw sound wave "icons".

    Parameter(s):
        _startTime - Wave propagation start time [NUMBER]
        _object - Object making the noise [OBJECT]
        _texRotation - Sound wave texture random rotation array [ARRAY]
        _noiseStrength - Noise strength for icon size coef [NUMBER]

    Returns:
        Sound wave was fully drawn/faded out [BOOL]

    Example(s):
        [parameter] call vgm_c_fnc_skill_investigate_drawSoundWaves
 */

params ["_startTime", "_object", "_texRotation", "_noiseStrength"];

private _extern_posASL = getPosASLVisual _object;
private _extern_sizeCoef = _noiseStrength;
private _extern_dist = getPosASLVisual player vectorDistance _extern_posASL;

private _fnc_drawIcon = {
    params ["_elapsed", "_rot"];

    // furher the sound the smaller the wave, stops scaling down past 100m
    private _iconSize = ICON_BASE_SIZE * ((ICON_BASE_DIST / _extern_dist) max (ICON_BASE_DIST / 100));
    _iconSize = _iconSize * _extern_sizeCoef;
    _iconSize = _iconSize * ((_elapsed * WAVE_SPEED));

    private _fadeStr = _elapsed / FADE_TIME_COEF;

    drawIcon3D [
        getMissionPath "SquiglyCircle_ca.paa",
        [0.9,1,1,ICON_ALPHA] vectorAdd [0,0,0, -_fadeStr],
        ASLToAGL _extern_posASL,
        _iconSize, _iconSize,
        _rot, "", 1, 0.05, "TahomaB"
    ];

    (ICON_ALPHA - _fadeStr) < 0 // return, has fully faded out
};

private _elapsed = time - _startTime;
{
    if (_elapsed < _x) then {continueWith false};
    private _drawCompleted = [(_elapsed - _x), _texRotation#_forEachIndex] call _fnc_drawIcon;
    _drawCompleted && (_x == WAVE_FINAL_START_TIME) // return, all waves were completed and last one faded out
} forEach [WAVE1_START_TIME, WAVE2_START_TIME, WAVE3_START_TIME] // return
