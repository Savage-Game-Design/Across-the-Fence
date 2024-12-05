/*
    File: fn_respawn_findFallbackSpawnTransform.sqf
    Author: Savage Game Design, Xorberax
    Public: No

    Description:
        Finds a suitable fallback spawn transform for when finding one near a team member fails.

    Parameter(s):
        _unit - The unit to find a safe spawn position for [OBJECT]
        _minDistanceFromTeam - The minimum distance to be from the team [NUMBER]
        _maxDistanceFromTeam - The maximum distance to be from the team [NUMBER]
        _minDistanceFromSelf - The minimum distance to be from the _unit's current position if no teammates were found [NUMBER]
        _maxDistanceFromSelf - The maximum distance to be from the _unit's current position if no teammates were found [NUMBER]

    Returns:
        [
            PositionASL: ASL position of safe spawn position,
            Direction: 0-360 degree direction to team
        ]

    Example(s):
        _fallbackSpawnTransform = [_unit, 300, 500] call vgm_g_fnc_respawn_findFallbackSpawnTransform;
*/

params [
    ["_unit", objNull, [objNull]],
    ["_minDistanceFromTeam", 25, [25]],
    ["_maxDistanceFromTeam", 100, [100]],
    ["_minDistanceFromSelf", 300, [300]],
    ["_maxDistanceFromSelf", 500, [500]]
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
if (_minDistanceFromSelf < 0) exitWith {
    ["ERROR", format ["Expected _minDistanceFromSelf to be greater than 0. Received _minDistanceFromSelf: %1", _minDistanceFromSelf]] call para_g_fnc_log;
};
if (_maxDistanceFromSelf < 0) exitWith {
    ["ERROR", format ["Expected _maxDistanceFromSelf to be greater than 0. Received _maxDistanceFromSelf: %1", _maxDistanceFromSelf]] call para_g_fnc_log;
};
if (_maxDistanceFromSelf <= _minDistanceFromSelf) exitWith {
    ["ERROR", format ["Expected _maxDistanceFromSelf to be greater than or equal to _minDistanceFromSelf. Received _minDistanceFromSelf: %1, _maxDistanceFromSelf: %2", _minDistanceFromSelf, _maxDistanceFromSelf]] call para_g_fnc_log;
};

private _unitGroup = group _unit;
private _fallbackSpawnUnitPositionASL = getPosASL (selectRandom ((units _unitGroup) select { alive _x && _x != _unit }));
if (isNil { _fallbackSpawnUnitPositionASL }) then { // no teammates to choose from, use self position
    _fallbackSpawnUnitPositionASL = getPosASL _unit;
};

private _fallbackSpawnPositionASL = AGLToASL (([_fallbackSpawnUnitPositionASL, _minDistanceFromTeam, _maxDistanceFromTeam, 5, 0, 30, 0, [], [[0, 0], [0, 0]]] call BIS_fnc_findSafePos) vectorAdd [0, 0, 0]);
if (_fallbackSpawnPositionASL isEqualTo [0, 0, 0]) exitWith { // worst case scenario: can't find a safe position near the team or self, so just use _unit's current transform
    [
        getPosASL _unit,
        getDir _unit
    ];
};

[
    _fallbackSpawnPositionASL,
    _fallbackSpawnPositionASL getDir _fallbackSpawnUnitPositionASL
];

