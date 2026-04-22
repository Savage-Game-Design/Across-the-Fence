#include "script_component.inc"
/*
    File: fn_getAnimCoef.sqf
    Author: Savage Game Design
    Date: 2023-08-19
    Last Update: 2026-04-22
    Public: No

    Description:
        Get animation stamina cost coefficient.

    Parameter(s):
        _anim - Animation name [STRING]

    Returns:
        Coefficient [NUMBER]

    Example(s):
        animationState player call vgm_c_fnc_stamina_getAnimCoef
 */

params ["_anim"];

vgm_stamina_animCoefCache getOrDefaultCall [_anim, {
    private _animType = _anim select [1, 3];

    call {
        // land movement
        if (_animType in ["idl", "mov", "adj"]) exitWith {
            private _stance = _anim select [5, 3];
            private _weaponState = _anim select [13, 3];

            private _stanceCoef = switch (_stance) do {
                case "knl": {COEF_KNL};
                case "pne": {COEF_PNE};
                default {COEF_STD};
            };

            switch (_weaponState) do {
                case "ras": {_stanceCoef * 1};
                case "low": {_stanceCoef * 1};
                default {_stanceCoef * 1};
            } // return
        };
        // swimming
        if (_animType in ["swm", "ssw", "bsw", "dve", "sdv", "bdv"]) exitWith {COEF_SWM};
        // other
        1
    };
}, true] // return
