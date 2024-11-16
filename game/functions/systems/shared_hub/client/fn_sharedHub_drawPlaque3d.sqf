/*
    File: fn_sharedHub_drawPlaque3D.sqf
    Author: Savage Game Design
    Date: 2024-11-16
    Last Update: 2024-11-16
    Public: Yes

    Description:
        Draws 3D text plaque on specified position.

    Parameter(s):
        _posATL - Position to draw the plaque [ARRAY]
        _text - Text string or array in format "primary text, secondary text" [STRING, ARRAY]

    Returns:
        Nothing

    Example(s):
        [getPosATL player vectorAdd [0,0,3], ["Player!", "hello player"]] call vgm_c_fnc_sharedHub_drawPlaque3d
 */

params [
    ["_posATL", nil, [[]], 3],
    ["_text", "", ["", []], 2]
];

private _widthCoef = getNumber (configFile >> "CfgInGameUI" >> "Cursor" >> "activeWidth");
_text params [["_textMain", ""], ["_textSecondary", ""]];
private _w1 = (_textMain getTextWidth ["RobotoCondensedBold", 0.04]) / _widthCoef;
private _w2 = (_textSecondary getTextWidth ["RobotoCondensedBold", 0.03]) / _widthCoef;
private _w = _w1 max _w2 + 0.016/_widthCoef;

// background
drawIcon3D [
    getMissionPath "assets\icon_3d_bg_ca.paa",
    [0, 0, 0, 0.5],
    _posATL,
    _w,
    2.8,
    0
];
// arrow
drawIcon3D [
    "\a3\ui_f\data\igui\cfg\actions\arrow_down_gs.paa",
    [1, 1, 1, 1],
    _posATL,
    0.55,
    0.55,
    2
];

// main text
drawIcon3D [
    "",
    [1, 1, 1, 1],
    _posATL,
    _w,
    -2.8,
    0,
    _text param [0, ""],
    2,
    0.04,
    "RobotoCondensedBold",
    "center"
];
// subtext
drawIcon3D [
    "",
    [0.9,0.9,0.9,1],
    _posATL,
    _w,
    -1.55,
    0,
    _text param [1, ""],
    2,
    0.03,
    "RobotoCondensedBold",
    "center"
];
