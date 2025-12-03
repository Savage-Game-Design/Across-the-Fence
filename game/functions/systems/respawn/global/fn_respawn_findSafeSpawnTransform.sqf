/*
	File: fn_respawn_findSafeSpawnTransformNearTeam.sqf
	Author: Savage Game Design, Xorberax
	Public: No

	Description:
		Finds the least-bad spawn position within the given parameters, avoiding enemies, water and locations inside objects.

		If a safe spawn can't be found,

	Parameter(s):
		_centerPos - Center of the spawn area [ARRAY]
		_minDistance - Minimum distance from the center of the spawn area [NUMBER]
		_maxDistance - Maximum distance from the center of the spawn area [NUMBER]
		_enemyAvoidanceHardBlockDistance - How close an enemy has to be to block spawning [NUMBER]
		_enemySides - The sides to consider as enemy [ARRAY]
		_friendlySide - The sides to consider as friends [ARRAY]

	Returns:
		[
			PositionASL: ASL position of safe spawn position,
			Direction: 0-360 degree direction to team
		]

	Example(s):
		_safeSpawnTransform = [_unit, 300, 500, 100] call vgm_g_fnc_respawn_findSafeSpawnTransform;
*/

#define MAX_SEARCH_ATTEMPTS 10
#define UNIT_CONSIDER_RANGE 100

params [
	"_centerPos",
	"_minDistance",
	"_maxDistance",
	["_enemyAvoidanceHardBlockDistance", 50, [50]],
	["_enemySides", [east, independent]],
	["_friendlySides", [west]]
];

private _blacklistedAreas = [];
private _finalLocations = [];

private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;

if (!isNil "_currentMission") then {
	private _targetBoxMarker = [_currentMission] call vgm_g_fnc_missions_getZoneMarker;
	[_targetBoxMarker] call vgm_g_fnc_loc_getTargetBoxBounds params ["_boxCenter", "_boxSize"];
	_boxSize params ["_boxHalfX", "_boxHalfY"];

	// Blacklist area pattern to prevent spawning outside of the target box.
	// ----------------------------------------
	// |        |                    |        |
	// |        |         Top        |        |
	// |        |                    |        |
	// |        |--------------------|        |
	// |        |                    |        |
	// |        |                    |        |
	// |  Left  |     Target box     |  Right |
	// |        |                    |        |
	// |        |                    |        |
	// |        |--------------------|        |
	// |        |                    |        |
	// |        |       Bottom       |        |
	// |        |                    |        |
	// ----------------------------------------

	#define BLACKLIST_BOX_HALF_SIZE 500

	_blacklistedAreas = [
		// Left target box boundary
		[_boxCenter vectorAdd [-_boxHalfX - BLACKLIST_BOX_HALF_SIZE, 0], BLACKLIST_BOX_HALF_SIZE, _boxHalfY + 2 * BLACKLIST_BOX_HALF_SIZE],
		// Right target box boundary
		[_boxCenter vectorAdd [_boxHalfX + BLACKLIST_BOX_HALF_SIZE, 0], BLACKLIST_BOX_HALF_SIZE, _boxHalfY + 2 * BLACKLIST_BOX_HALF_SIZE],
		// Top target box boundary
		[_boxCenter vectorAdd [0,_boxHalfY + BLACKLIST_BOX_HALF_SIZE], _boxHalfX, BLACKLIST_BOX_HALF_SIZE],
		// Bottom target box boundary
		[_boxCenter vectorAdd [0, -_boxHalfY - BLACKLIST_BOX_HALF_SIZE], _boxHalfX, BLACKLIST_BOX_HALF_SIZE]

	];
};

for "_searchAttempt" from 1 to MAX_SEARCH_ATTEMPTS do {
	private _safePosition = [_centerPos, _minDistance, _maxDistance, 5, 0, 30, 0, _blacklistedAreas, [[0, 0], [0, 0]]] call BIS_fnc_findSafePos;

	if (_safePosition isEqualTo [0, 0]) then { continue; };

	private _hardBlockingUnits = _safePosition nearEntities ["CAManBase", _enemyAvoidanceHardBlockDistance] select { side _x in _enemySides && alive _x };

	if (_hardBlockingUnits isNotEqualTo []) then { continue; };

	private _nearbyUnits = _safePosition nearEntities ["CAManBase", UNIT_CONSIDER_RANGE];
	private _badnessScore = 0;

	{
        if (alive _x and _x isNotEqualTo player) then {
            _badnessScore = _badnessScore + linearConversion [0, UNIT_CONSIDER_RANGE, _safePosition distance2D getPosATL _x, 100, 50, true];
        };
	} forEach _nearbyUnits;

	// Ensure position 3D format
	_safePosition set [2, 0];
	_finalLocations pushBack [_badnessScore, AGLtoASL _safePosition];
};

if (_finalLocations isEqualTo []) exitWith {
	["Respawn: unable to find a safe location without enemies, using arbitrary safe position"] call vgm_g_fnc_logWarning;
	private _safePosition = [_centerPos, 0, _maxDistance, 5, 0, 30, 0, _blacklistedAreas, [[0, 0], [0, 0]]] call BIS_fnc_findSafePos;
	if (_safePosition isEqualTo [0, 0]) then {
		["Respawn: unable to find arbitrary safe position, using center of search area"] call vgm_g_fnc_logWarning;
		[_centerPos, 0, 0]
	} else {
		// Ensure position 3D format
		_safePosition set [2, 0];
		[AGLtoASL _safePosition, _safePosition getDir _centerPos]
	}
};

// Sort by ascending badness.
_finalLocations sort true;

[_finalLocations # 0 # 1, (_finalLocations # 0 # 1) getDir _centerPos]
