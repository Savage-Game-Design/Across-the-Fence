/*
    File: fn_zombie_chase.sqf
    Author: Savage Game Design
    Date: 2025-10-20
    Last Update: 2025-10-29
    Public: No

    Description:
        Performs the zombie's chase behaviour. vgm_l_zombie_chaseTarget must be set. Intended to be used from the FSM.

    Parameter(s):
        _zombie - Unit to use [UNIT]

    Returns:
        Nothing

    Example(s):
        [_zombie] call vgm_g_fnc_zombie_chase
 */

params ["_zombie"];

if (time < _zombie getVariable ["vgm_l_zombie_chaseNextTick", 0]) exitWith {};

private _chaseTarget = _zombie getVariable ["vgm_l_zombie_chaseTarget", objNull];

[_zombie, "aggressive", [8, 16]] call vgm_g_fnc_zombie_ambientNoise;

private _distance = _zombie distance2D _chaseTarget;
private _delay = linearConversion [10, 30, _distance , 0.2, 2, true];

_zombie setVariable ["vgm_l_zombie_chaseLastTick", time];
_zombie setVariable ["vgm_l_zombie_chaseNextTick", time + _delay];

private _prevDest = _zombie getVariable ["vgm_l_zombie_chaseDest", [-9999, -9999, 0]];
private _dest = getPosATL _chaseTarget;
private _tolerance = linearConversion [5, 30, _distance, 0.5, 10, true];

if (_tolerance < _dest distance _prevDest) then {
    _zombie doMove _dest;
    _zombie setVariable ["vgm_l_zombie_chaseDest", _dest];
};
