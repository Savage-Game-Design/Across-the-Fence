#include "script_component.inc"
/*
    File: fn_medical_statusEffectBleeding.sqf
    Author: Savage Game Design
    Date: 2023-07-24
    Last Update: 2025-11-29
    Public: No

    Description:
        Handle bleeding status effect.

    Parameter(s):
        _unit - Unit with the status effect [OBJECT]
        _bleeding - Bleeding status [BOOL]

    Returns:
        Nothing

    Example(s):
        [player, true] call vgm_c_fnc_medical_statusEffectBleeding
 */

params ["_unit", "_bleeding"];

if (!_bleeding) exitWith {
    format ["Stopping bleed out loop: %1", _unit] call vgm_g_fnc_logInfo;

    removeMissionEventHandler ["EachFrame", _unit getVariable ["vgm_c_medical_bleedingEachFrameEH", -1]];

    _unit setVariable ["vgm_g_medical_bleeding", false, true];
    _unit setVariable ["vgm_c_medical_bleedOutAt", nil];
    _unit setVariable ["vgm_c_medical_bleedingEachFrameEH", nil];

    if (isPlayer _unit) then {-1 call vgm_c_fnc_medical_feedbackBleeding};
};

private _bleedOutTime = BLEED_OUT_TIME * ([_unit, "bleedOut"] call vgm_c_fnc_coefficient_get);

// visual bleeding effect, stops when `damage _unit` < 0.1
_unit setBleedingRemaining _bleedOutTime;

_unit setVariable ["vgm_g_medical_bleeding", true, true];
_unit setVariable ["vgm_c_medical_bleedOutAt", time + _bleedOutTime];

format ["Starting bleed out loop: %1", _unit] call vgm_g_fnc_logInfo;

#define TICK_TIME 1
private _eh = addMissionEventHandler ["EachFrame", {
    _thisArgs params ["_deltaT", "_unit"];

    if (_unit call vgm_g_fnc_medical_isUnconscious) exitWith {
        if (isPlayer _unit) then {"vgm_medical_bleeding" cutText ["", "PLAIN"]};
        [_unit, "bleeding", "medical"] call vgm_c_fnc_statusEffect_remove;
    };

    private _bleedOutAt = _unit getVariable "vgm_c_medical_bleedOutAt";
    _deltaT = _deltaT + diag_deltaTime;

    if (_deltaT >= TICK_TIME) then {
        _deltaT = _deltaT mod TICK_TIME;

        private _remainingTime = _bleedOutAt - time;
        if (_remainingTime <= 0) exitWith {
            if (isPlayer _unit) then {
                0 call vgm_c_fnc_medical_feedbackBleeding;
                "vgm_medical_bleeding" cutText ["", "PLAIN"]
            };
            _unit call vgm_c_fnc_medical_setUnconscious;
        };

        if (isPlayer _unit) then {
            _remainingTime call vgm_c_fnc_medical_feedbackBleeding;
            #ifdef DEBUG
            "vgm_medical_bleeding" cutText [format ["<t size='1.5'>Bleeding out - %1</t>", _remainingTime toFixed 0], "PLAIN DOWN", -1, true, true];
            #endif
        };
    };

    _thisArgs set [0, _deltaT];
}, [0, _unit]];

_unit setVariable ["vgm_c_medical_bleedingEachFrameEH", _eh];
