/*
    File: fn_medical_setUnconscious.sqf
    Author: Savage Game Design
    Date: 2023-07-23
    Last Update: 2025-02-06
    Public: Yes

    Description:
        Set unconsciousness state of the unit.

    Parameter(s):
        _unit - Unit to affect [OBJECT]
        _state - State of the unit unconsciousness [BOOL, defaults to true]

    Returns:
        Nothing

    Example(s):
        [player, true] call vgm_c_fnc_medical_setUnconscious
 */

params ["_unit", ["_state", true]];

_unit setUnconscious _state;
_unit setCaptive _state;

private _previousLifeState = _unit getVariable "vgm_g_medical_isUnconscious";

if (_previousLifeState != _state) then {
    _unit setVariable ["vgm_g_medical_isUnconscious", _state, true];

    ["vgm_medical_unconscious", [_unit, _state]] call para_g_fnc_event_triggerServerAndLocal;
    // prevent being stuck in unconscious animation if no weapon
    if (!_state && {currentWeapon _unit == "" || (currentWeapon _unit == binocular _unit)}) then {
        _unit playMoveNow "UnconsciousOutProne";
    };
};

nil
