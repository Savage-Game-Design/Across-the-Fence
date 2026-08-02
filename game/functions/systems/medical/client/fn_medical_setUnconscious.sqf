#include "script_component.inc"
/*
    File: fn_medical_setUnconscious.sqf
    Author: Savage Game Design
    Date: 2023-07-23
    Last Update: 2026-03-05
    Public: Yes

    Description:
        Legacy wrapper — SOG Advanced Revive now owns the unconscious state
        for players (no-op for players). For AI targets (snatch/bright light),
        this still sets the VGM variable and fires the event.

    Parameter(s):
        _unit - Unit to affect [OBJECT]
        _state - State of the unit unconsciousness [BOOL, defaults to true]

    Returns:
        Nothing

    Example(s):
        [player, true] call vgm_c_fnc_medical_setUnconscious
 */

params ["_unit", ["_state", true]];

// For players, SOG owns the unconscious state — the sync loop in postInit
// handles syncing vn_revive_incapacitated → vgm_g_medical_isUnconscious.
// VGM injury effects / bleeding should NOT override SOG's state.
if (isPlayer _unit) exitWith {nil};

// For AI targets (snatch officer, bright light pilot): set VGM variable + fire event
private _previousState = _unit getVariable ["vgm_g_medical_isUnconscious", false];

if (_previousState != _state) then {
    _unit setVariable ["vgm_g_medical_isUnconscious", _state, true];

    if (_state) then {
        _unit setUnconscious true;
        _unit setCaptive true;
    } else {
        _unit setUnconscious false;
        _unit setCaptive false;
    };

    ["vgm_medical_unconscious", [_unit, _state]] call para_g_fnc_event_triggerServerAndLocal;
};

nil
