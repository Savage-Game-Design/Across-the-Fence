/*
    File: fn_respawn_findSafeSpawnTransformNearTeam.sqf
    Author: Savage Game Design, Xorberax
    Public: No

    Description:
        Finds a safe spawn transform for a unit, around a random team member, between a specified distance, avoiding enemies and water.
        If a safe transform could not be found, the transform of the marker named "initial_spawn_point" will be returned instead.

    Parameter(s):
        _unit - The unit to find a safe spawn position for [OBJECT]
        _minDistanceFromTeam - The minimum distance to search away from teammates [NUMBER]
        _maxDistanceFromTeam - The maximum distance to search away from teammates [NUMBER]
        _enemyAvoidanceDistance - The distance to search to avoid enemies and friendlies [NUMBER]

    Returns:
        [
            PositionASL: ASL position of safe spawn position,
            Direction: 0-360 degree direction to team
        ]

    Example(s):
        _safeSpawnTransform = [_unit, 300, 500, 100] call vgm_s_fnc_respawn_findSafeSpawnTransformNearTeam;
*/

#define MAX_SEARCH_ATTEMPTS 5

params [
    ["_unit", objNull, [objNull]],
    ["_minDistanceFromTeam", 300, [300]],
    ["_maxDistanceFromTeam", 500, [500]],
    ["_enemyAvoidanceDistance", 100, [100]]
];

if (isNull _unit) exitWith {
    ["ERROR", format ["Expected _unit to be defined. Received _unit: %1", _unit]] call para_g_fnc_log;
};
if (!(_unit isKindOf "CAManBase")) exitWith {
    ["ERROR", format ["Expected _unit to be of type CAManBase. Received typeOf _unit: %1", typeOf _unit]] call para_g_fnc_log;
};
if (_minDistanceFromTeam < 0) exitWith {
    ["ERROR", format ["Expected _minDistanceFromTeam to be greater than 0. Received _minDistanceFromTeam: %1", _minDistanceFromTeam]] call para_g_fnc_log;
};
if (_maxDistanceFromTeam < 0) exitWith {
    ["ERROR", format ["Expected _maxDistanceFromTeam to be greater than 0. Received _maxDistanceFromTeam: %1", _maxDistanceFromTeam]] call para_g_fnc_log;
};
if (_maxDistanceFromTeam <= _minDistanceFromTeam) exitWith {
    ["ERROR", format ["Expected _maxDistanceFromTeam to be greater than or equal to _minDistanceFromTeam. Received _minDistanceFromTeam: %1, _maxDistanceFromTeam: %2", _minDistanceFromTeam, _maxDistanceFromTeam]] call para_g_fnc_log;
};
if (_enemyAvoidanceDistance < 0) exitWith {
    ["ERROR", format ["Expected _enemyAvoidanceDistance to be greater than 0. Received _enemyAvoidanceDistance: %1", _enemyAvoidanceDistance]] call para_g_fnc_log;
};

private _safeSpawnTransform = call vgm_s_fnc_respawn_getInitialSpawnPointMarkerTransform; // fallback spawn position if a safe one can't be found near teammates
private _groupPositionAGL = [
    group _unit,
    {
        params ["_unit", "_args"];
        _args params ["_unitToRespawn"];
        alive _unit && _unit != _unitToRespawn;
    },
    [_unit]
] call para_g_fnc_get_group_majority_position;
if (_groupPositionAGL isEqualTo [0, 0, 0]) exitWith {
    _safeSpawnTransform;
};

private _enemySides = ([side _unit] call BIS_fnc_enemySides) createHashMapFromArray [];
_groupPositionASL = AGLToASL _groupPositionAGL;

for "_searchAttempt" from 1 to MAX_SEARCH_ATTEMPTS do {
    private _safePosition = [_groupPositionASL, _minDistanceFromTeam, _maxDistanceFromTeam, 5, 0, 30, 0, [], [[0, 0], [0, 0]]] call BIS_fnc_findSafePos;
    if (!(_safePosition isEqualTo [0, 0])) then {
        _safePosition = AGLToASL [_safePosition#0, _safePosition#1, 0];
        private _totalNearbyEnemies = { side _x in _enemySides } count (_safePosition nearEntities ["AllVehicles", _enemyAvoidanceDistance]);
        private _totalNearbyFriendlies = { !(side _x in _enemySides) } count (_safePosition nearEntities ["AllVehicles", _minDistanceFromTeam]);
        if (_totalNearbyEnemies == 0 && _totalNearbyFriendlies == 0) then { // TODO: line of sight checks with enemies and unit's group
            _safeSpawnTransform = [_safePosition, _safePosition getDir _groupPositionASL];
            break;
        };
    }
};

_safeSpawnTransform;
