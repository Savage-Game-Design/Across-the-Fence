/*
    File: fn_zombie_nearestTarget.sqf
    Author: Savage Game Design
    Date: 2025-10-19
    Last Update: 2025-10-29
    Public: No

    Description:
        Gets the nearest valid target for the zombie

    Parameter(s):
        _zombie - Unit to use [UNIT]

    Returns:
        Nearest valid target, or objNull [OBJECT]

    Example(s):
        [cursorObject] call vgm_g_fnc_zombie_nearestTarget;
 */

params ["_zombie"];

if (time < (_zombie getVariable ["vgm_l_zombie_lastTargetScan", 0]) + 0.5) exitWith {
    _zombie getVariable ["vgm_l_zombie_lastTargetScanResult", objNull]
};
_zombie setVariable ["vgm_l_zombie_lastTargetScan", time];

private _targetsWithDist =
    (_zombie targets [true, _zombie getVariable "vgm_l_zombie_aggroRange", [west, east, civilian, resistance]])
    apply { [_zombie distance2D _x, _x] };

_targetsWithDist sort true;

private _index = _targetsWithDist findIf { [_zombie, _x # 1] call vgm_g_fnc_zombie_isValidTarget };

private _result = if (_index < 0) then { objNull } else { _targetsWithDist # _index # 1 };

_zombie setVariable ["vgm_l_zombie_lastTargetScanResult", _result];

_result



