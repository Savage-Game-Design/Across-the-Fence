/*
    File: fn_suppression_add.sqf
    Author: Savage Game Design
    Date: 2024-02-09
    Last Update: 2024-02-09
    Public: Yes

    Description:
        Adds VGM suppression to the target.

        Note: Only works where the unit is local.

    Parameter(s):
        _unit - Unit to add suppression to [OBJECT]
        _amount - Amount of suppression to add [NUMBER]
        _shooter - Unit shooting [OBJECT]

    Returns:
        Total suppression [NUMBER]

    Example(s):
        [cursorObject, 0.2] call vgm_g_fnc_suppression_add;
 */

params ["_unit", "_amount", ["_shooter", objNull]];

private _currentSuppression = _unit getVariable ["vgm_l_suppression_value", 0];
private _shooterMultiplier = _shooter getVariable ["vgm_g_suppression_multiplier", 1];

private _newSuppression = (_currentSuppression + (_amount * _shooterMultiplier)) min 1 max 0;

if (_currentSuppression <= 0 && _newSuppression > 0) then {
    _unit setVariable ["vgm_l_suppression_decayWindowStart", serverTime];
};

_unit setVariable ["vgm_l_suppression_value", _newSuppression];

[_unit, _newSuppression] call vgm_g_fnc_suppression_updateEffects;

_newSuppression
