/*
    File: fn_respawn_findSafeSpawnPositionNearTeam.sqf
    Author: Savage Game Design
    Public: Yes

    Description:
        Finds a safe spawn position for a unit, around a random team member, between a specified distance, avoiding enemies and water.
        If a safe position could not be found, the position of the marker named "initial_spawn_point" will be returned instead.

    Parameter(s):
        _unit - The unit to find a safe spawn position for [OBJECT]
        _minDistanceFromTeam - The minimum distance to search away from teammates [NUMBER]
        _maxDistanceFromTeam - The maximum distance to search away from teammates [NUMBER]
        _enemyAvoidanceDistance - The distance to search and avoid enemies [NUMBER]

    Returns:
        ASL position of a safe spawn position for the given unit

    Example(s):
        _safeSpawnPosition = [_unit, 100, 200, 100] call VGM_S_fnc_respawn_findSafeSpawnPositionNearTeam;
*/

#define MAX_SEARCH_ATTEMPTS 8
#define SEARCH_ANGLE 360 / MAX_SEARCH_ATTEMPTS

params [
    ["_unit", objNull, [objNull]],
    ["_minDistanceFromTeam", 300, [300]],
    ["_maxDistanceFromTeam", 500, [500]],
    ["_enemyAvoidanceDistance", 100, [100]]
];

if (isNull _unit) exitWith {
    ["Expected _unit to be defined. Received _unit: %1", _unit] call BIS_fnc_error;
};
if (!(_unit isKindOf "CAManBase")) exitWith {
    ["Expected _unit to be of type CAManBase. Received typeOf _unit: %1", typeOf _unit] call BIS_fnc_error;
};
if (_minDistanceFromTeam < 0) exitWith {
    ["Expected _minDistanceFromTeam to be greater than 0. Received _minDistanceFromTeam: %1", _minDistanceFromTeam] call BIS_fnc_error;
};
if (_maxDistanceFromTeam < 0) exitWith {
    ["Expected _maxDistanceFromTeam to be greater than 0. Received _maxDistanceFromTeam: %1", _maxDistanceFromTeam] call BIS_fnc_error;
};
if (_maxDistanceFromTeam <= _minDistanceFromTeam) exitWith {
    ["Expected _maxDistanceFromTeam to be greater than or equal to _minDistanceFromTeam. Received _minDistanceFromTeam: %1, _maxDistanceFromTeam: %2", _minDistanceFromTeam, _maxDistanceFromTeam] call BIS_fnc_error;
};
if (_enemyAvoidanceDistance < 0) exitWith {
    ["Expected _enemyAvoidanceDistance to be greater than 0. Received _enemyAvoidanceDistance: %1", _enemyAvoidanceDistance] call BIS_fnc_error;
};

private _spawnPosition = call VGM_s_fnc_respawn_getInitialSpawnPointMarkerPosition;
private _eligbleUnitsInGroup = (units (group _unit)) select { alive _x && _x != _unit }; // TODO: check for downed state
if (count _eligbleUnitsInGroup == 0) exitWith {
    _spawnPosition;
};

private _unitSide = side _unit;
private _initialSearchDirection = random 360;
private _searchRadius = (_maxDistanceFromTeam - _minDistanceFromTeam) / 2;
private _searchCircleDistanceFromTargetUnit = _minDistanceFromTeam + _searchRadius;
private _targetUnit = selectRandom _eligbleUnitsInGroup;
private _targetUnitPositionASL = getPosASL _targetUnit;

// imagine the search circle rolling around the circumference of the target unit
for "_searchAttempt" from 1 to MAX_SEARCH_ATTEMPTS do {
    private _searchDirection = _initialSearchDirection + (SEARCH_ANGLE * _searchAttempt);
    private _searchOriginASL = _targetUnitPositionASL vectorAdd [
        _searchCircleDistanceFromTargetUnit * (cos _searchDirection),
        _searchCircleDistanceFromTargetUnit * (sin _searchDirection),
        0
    ];

    private _safePosition = [_searchOriginASL, 0, _searchRadius, 5, 0, 30, 0, [], [[0, 0], [0, 0]]] call BIS_fnc_findSafePos;
    if (!(_safePosition isEqualTo [0, 0])) then {
        _safePosition = AGLToASL [_safePosition select 0, _safePosition select 1, 0];

        // TODO: line of sight checks with enemies and unit's group
        private _totalNearbyEnemies = _unit countEnemy (_safePosition nearEntities ["AllVehicles", _enemyAvoidanceDistance]);
        if (_totalNearbyEnemies == 0) then {
            _spawnPosition = _safePosition;
            break;
        };
    }
};

_spawnPosition;
