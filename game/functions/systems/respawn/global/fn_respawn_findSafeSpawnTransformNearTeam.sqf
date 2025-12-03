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
        _safeSpawnTransform = [_unit, 300, 500, 100] call vgm_g_fnc_respawn_findSafeSpawnTransformNearTeam;
*/

params [
    ["_unit", objNull, [objNull]],
    ["_minDistanceFromTeam", 200, [200]],
    ["_maxDistanceFromTeam", 500, [500]],
	["_enemyAvoidanceHardBlockDistance", 50, [50]],
	["_enemySides", [east, independent], [[]]],
	["_friendlySides", [west], [[]]]
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
if (_enemyAvoidanceHardBlockDistance < 0) exitWith {
    ["ERROR", format ["Expected _enemyAvoidanceDistance to be greater than 0. Received _enemyAvoidanceDistance: %1", _enemyAvoidanceDistance]] call para_g_fnc_log;
};

private _unitGroup = group _unit;
private _groupPositionATL = [
    _unitGroup,
    [
        [_unit],
        {
            params ["_unit", "_args"];
            _args params ["_unitToRespawn"];
            alive _unit && _unit != _unitToRespawn;
        }
    ]
] call para_g_fnc_get_group_majority_position;

// couldn't determine group position. maybe all dead, or no other group members (single player)
// use player's existing position as basis for starting the search
if (_groupPositionATL isEqualTo [0, 0, 0]) then {
    _groupPositionATL = getPosATL _unit;
};

[
    _groupPositionATL,
    _minDistanceFromTeam,
    _maxDistanceFromTeam,
    _enemyAvoidanceHardBlockDistance,
    _enemySides,
    _friendlySides
] call vgm_g_fnc_respawn_findSafeSpawnTransform
