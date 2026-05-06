#include "script_component.inc"

/*
    File: fn_skill_investigate_queueIcon.sqf
    Author: Savage Game Design
    Date: 2024-02-11
    Last Update: 2026-05-06
    Public: No

    Description:
        Queue noise for drawing.

    Parameter(s):
        _object - Noise source

    Returns:
        Nothing

    Example(s):
        [selectRandom units _group, 2] call vgm_c_fnc_skill_investigate_queueNoise
 */

params [
    "_object",
    ["_drawSizeCoef", 1],
    ["_drawOffset", [0,0,0]],
    ["_color", ICON_COLOR_WHITE]
];

vgm_c_skill_investigate_noises pushBack [
    time,
    _object,
    [random 360, random 360, random 360],
    // Boost draw size to increase visibility of waves at range.
    _drawSizeCoef * (player getVariable ["vgm_c_skill_investigate_rangeMultiplier", 1]),
    _drawOffset,
    _color
];
