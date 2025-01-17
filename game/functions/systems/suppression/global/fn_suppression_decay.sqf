/*
    File: fn_suppression_decay.sqf
    Author: Savage Game Design
    Date: 2024-02-09
    Last Update: 2025-01-17
    Public: Yes

    Description:
        Decays suppression based on amount of time passed.

        Note: Only works where the unit is local.

    Parameter(s):
        _unit - Unit to decay suppression on [OBJECT]

    Returns:
        Nothing

    Example(s):
        [cursorObject] call vgm_g_fnc_suppression_decay;
 */
params ["_unit"];

// Decay rate should be a variable for easy changes during testing.
private _decayRatePerSecond = missionNamespace getVariable ["vgm_g_suppression_decayRatePerSecond", 0.05];

private _lastDecay = _unit getVariable ["vgm_l_suppression_lastDecay", 0];

// When the unit last went from 0 suppression to > 0.
// Without this, _lastDecay could be counting time when suppression was 0, and decay too fast.
private _decayWindowStart = _unit getVariable ["vgm_l_suppression_decayWindowStart", 0];

private _timePassed = time - (_lastDecay max _decayWindowStart);
private _newSuppression = ((_unit getVariable ["vgm_l_suppression_value", 0]) - _timePassed * _decayRatePerSecond) max 0;

_unit setSuppression _newSuppression;
_unit setVariable ["vgm_l_suppression_value", _newSuppression];
_unit setVariable ["vgm_l_suppression_lastDecay", time];
[_unit, _newSuppression] call vgm_g_fnc_suppression_updateEffects;
