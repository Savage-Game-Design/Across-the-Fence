/*
    File: fn_skill_actives_keenEye.sqf
    Author: Savage Game Design
    Date: 2025-08-18
    Last Update: 2025-08-18
    Public: No

    Description:
        Activates the "Keen eye" skill

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_keenEye
 */

#define RANGE 50
#define ARC_START 330
#define ARC_END 30

params ["", "_skill"];

["Keen eye skill activated"] call vgm_g_fnc_logInfo;

private _hintsInRange = [getPosATL player, RANGE] call vgm_c_fnc_sites_hints_getHintsInRange;

private _hintsInArc = _hintsInRange select {
    private _relDir = player getRelDir _x;
    ARC_START < _relDir || _relDir < ARC_END
};

private _hintsSorted = _hintsInArc apply {[player distance _x, _x]};
_hintsSorted sort true;


if (_hintsSorted isNotEqualTo []) exitWith {
    [_hintsSorted # 0 # 1] call vgm_c_fnc_sites_hints_inspect;
};
