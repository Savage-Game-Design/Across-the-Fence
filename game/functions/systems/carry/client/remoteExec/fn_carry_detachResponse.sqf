/*
    File: fn_carry_detachResponse.sqf
    Author: Savage Game Design
    Date: 2023-12-01
    Last Update: 2026-01-14
    Public: No

    Description:
        Handle server response for detach request.

    Parameter(s):
        _unit - Unit doing the attach [OBJECT]
        _target - Attached target [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_unit, _target] remoteExec ["vgm_c_fnc_carry_detachResponse", _unit];
 */

params ["_unit", "_target"];

format ["Detached: %1 | %2", _unit, _target] call vgm_g_fnc_logInfo;

_unit removeAction (_unit getVariable ["vgm_carry_actionDrop", -1]);
_unit removeAction (_unit getVariable ["vgm_carry_actionLoad", -1]);

[_unit, "forceWalk", "carry"] call vgm_c_fnc_statusEffect_remove;
[_unit, "animSpeed", "carry"] call vgm_c_fnc_coefficient_remove;
