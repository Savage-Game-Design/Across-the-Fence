/*
    File: fn_mortar_getTeamCentroid.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Computes the average position (centroid) of all alive units in the given array.

    Parameter(s):
        _units - Array of units to average [Array]

    Returns:
        Position ASL of centroid, or [0,0,0] if no alive units [Array]

    Example(s):
        private _centroid = [_missionPlayers] call vgm_s_fnc_mortar_getTeamCentroid;
*/

params ["_units"];

private _alive = _units select { alive _x };
if (count _alive == 0) exitWith { [0, 0, 0] };

private _sumX = 0;
private _sumY = 0;
private _sumZ = 0;

{
    private _pos = getPosASL _x;
    _sumX = _sumX + (_pos # 0);
    _sumY = _sumY + (_pos # 1);
    _sumZ = _sumZ + (_pos # 2);
} forEach _alive;

private _count = count _alive;
[_sumX / _count, _sumY / _count, _sumZ / _count]
