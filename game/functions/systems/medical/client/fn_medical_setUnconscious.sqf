/*
    File: fn_medical_setUnconscious.sqf
    Author: Savage Game Design
    Date: 2023-07-23
    Last Update: 2023-07-23
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

private _previousLifeState = lifeState _unit;

_unit setUnconscious _state;

if (lifeState _unit != _previousLifeState) then {
    ["vgm_medical_unconscious", [_unit, _state]] call para_g_fnc_event_triggerLocal;
};

nil
