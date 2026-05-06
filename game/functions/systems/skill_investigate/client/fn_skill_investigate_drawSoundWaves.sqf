#include "script_component.inc"
/*
    File: fn_skill_investigate_drawSoundWaves.sqf
    Author: Savage Game Design
    Date: 2024-01-22
    Last Update: 2026-05-06
    Public: No

    Description:
        Draw sound wave "icons".

    Parameter(s):
        _startTime - Wave propagation start time [NUMBER]
        _object - Object making the noise [OBJECT]
        _texRotation - Sound wave texture random rotation array [ARRAY]
        _noiseStrength - Noise strength for icon size coef [NUMBER]
        _color - Color of the waves [ARRAY]


    Returns:
        Sound wave was fully drawn/faded out [BOOL]

    Example(s):
        [parameter] call vgm_c_fnc_skill_investigate_drawSoundWaves
 */

params ["_startTime", "_object", "_texRotation", "_noiseStrength", "_drawOffset", ["_color", ICON_COLOR_WHITE]];

private _extern_posAGL = _object modelToWorldVisual _drawOffset;
private _extern_sizeCoef = _noiseStrength;
private _extern_dist = getPosATLVisual player vectorDistance _extern_posAGL;

private _fnc_drawIcon = {
    params ["_elapsed", "_rot"];

    // Sound wave scales down with distance
    private _iconSize = ICON_BASE_SIZE * (linearConversion [0, 2 * ICON_HALF_SIZE_DIST, _extern_dist, 1, 0] max ICON_MIN_SIZE_PERCENTAGE);
    _iconSize = _iconSize * _extern_sizeCoef;
    _iconSize = _iconSize * ((_elapsed * WAVE_SPEED));

    private _fadeStr = _elapsed / FADE_TIME_COEF;

    drawIcon3D [
        getMissionPath "SquiglyCircle_ca.paa",
        _color vectorAdd [0,0,0, -_fadeStr],
        _extern_posAGL,
        _iconSize, _iconSize,
        _rot, "", 1, 0.05, "TahomaB"
    ];

    ((_color # 3) - _fadeStr) < 0 // return, has fully faded out
};

private _elapsed = time - _startTime;
{
    if (_elapsed < _x) then {continueWith false};
    private _drawCompleted = [(_elapsed - _x), _texRotation#_forEachIndex] call _fnc_drawIcon;
    _drawCompleted && (_x == WAVE_FINAL_START_TIME) // return, all waves were completed and last one faded out
} forEach [WAVE1_START_TIME, WAVE2_START_TIME, WAVE3_START_TIME] // return
