#include "script_component.inc"
/*
    File: fn_getAnimCoef.sqf
    Author: Savage Game Design
    Date: 2023-08-19
    Last Update: 2023-08-19
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
            switch (_anim select [5, 3]) do {
                case ("knl"): {COEF_KNL};
                case ("pne"): {COEF_PNE};
                default {COEF_STD};
            };
        };
        // swimming
        if (_animType in ["swm", "ssw", "bsw", "dve", "sdv", "bdv"]) exitWith {COEF_SWM};
        // other
        1
    };
}, true] // return
