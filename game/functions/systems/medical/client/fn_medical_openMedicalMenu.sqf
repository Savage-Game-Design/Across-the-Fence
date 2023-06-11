/*
    File: fn_medical_openMedicalMenu.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-06-11
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [] call vgm_c_fnc_medical_openMedicalMenu;
 */

private _target = cursorTarget;
if (!(_target isKindOf "CAManBase") || {player distance _target > 15}) then {
    _target = player;
};

private _display = findDisplay 46 createDisplay "RscDisplayEmpty";

// hitpoints list, indented to show "depends" relation
private _hitpoints = [
    "hitbody",
        "hitpelvis",
        "hitabdomen",
        "hitdiaphragm",
        "hitchest",
    "hithands",
        "hitarms",
    "hithead",
        "hitface",
        "hitneck",
    "hitlegs"
];

private _w = safeZoneW/3.5;
private _h = safeZoneH/2;

private _ctrlContainer = _display ctrlCreate ["RscControlsGroupNoScrollBars", -1];
_ctrlContainer ctrlSetPosition [
    safeZoneX + safeZoneW/2 - _w/2, safeZoneY + safeZoneH/2 - _h/2,
    _w, _h
];
_ctrlContainer ctrlCommit 0;

ctrlPosition _ctrlContainer params ["_x", "_y", "_w", "_h"];

private _ctrlBg = _display ctrlCreate ["RscText", -1, _ctrlContainer];
_ctrlBg ctrlSetBackgroundColor [0,0,0,0.4];
_ctrlBg ctrlSetPosition [0, 0, _w, _h];
_ctrlBg ctrlCommit 0;

_h = _h/count _hitpoints;

private _ctrlHeader = _display ctrlCreate ["RscText", -1];
_ctrlHeader ctrlSetText name _target;
_ctrlHeader ctrlSetBackgroundColor [0,0,0,1];
_ctrlHeader ctrlSetPosition [_x, _y - _h, _w, _h];
_ctrlHeader ctrlCommit 0;

_w = _w/3;
{
    private _ctrlLabel = _display ctrlCreate ["RscText", -1, _ctrlContainer];
    _ctrlLabel ctrlSetText _x;
    _ctrlLabel ctrlSetPosition [_w*0, _h * _forEachIndex, _w, _h];
    _ctrlLabel ctrlCommit 0;

    private _ctrlDmg = _display ctrlCreate ["RscText", -1, _ctrlContainer];
    _ctrlDmg ctrlSetText str (_target getHitPointDamage _x);
    _ctrlDmg ctrlSetPosition [_w*1, _h * _forEachIndex, _w, _h];
    _ctrlDmg ctrlCommit 0;
} forEach _hitpoints;
