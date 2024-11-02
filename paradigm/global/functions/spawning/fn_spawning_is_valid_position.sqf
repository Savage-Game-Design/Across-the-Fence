/*
    File: fn_spawning_is_valid_position.sqf
    Author: Savage Game Design
    Date: 2024-11-02
    Last Update: 2024-11-02
    Public: Yes

    Description:
        Checks if a position is a valid spawn position, based on the provided parameters.

    Parameter(s):
 		_posASL - Position to check [PosASL]
		_blockingUnits - Units that prevent spawning near them [ARRAY, defaults to <playableUnits>]
        _softBlockRadius - The maximum distance at which we perform line of sight checks [NUMBER]
        _hardBlockRadius - The absolute minimum distance the spawn point needs to be from a blocking unit [NUMBER]
        _doVisibilityChecks - Should visibility checks be run? Check is faster if they're disabled [BOOL]

    Returns:
        [
            Is position a valid spawn position? [BOOL],
            Unit that blocked the spawn [UNIT]
        ]

    Example(s):
        [[0, 0, 0], [allPlayers], 600, 200] call para_g_fnc_spawning_is_valid_position;
 */

params ["_posASL", ["_blockingUnits", playableUnits], ["_softBlockRadius", 600], ["_hardBlockRadius", 200], ["_doVisibilityChecks", true]];

private _unitsNearPosIndexes = _blockingUnits inAreaArrayIndexes [_posASL, _softBlockRadius, _softBlockRadius, 0, false];

if (_unitsNearPosIndexes isEqualTo []) exitWith { [ true, objNull ] };

//Check if any units are within the hard block radius - squads should *never* spawn in this radius
private _hardBlockUnitsIndexes = _blockingUnits inAreaArrayIndexes [_posASL, _hardBlockRadius, _hardBlockRadius, 0, false];

if !(_hardBlockUnitsIndexes isEqualTo []) exitWith { [ false, _blockingUnits # (_hardBlockUnitsIndexes # 0)] };

if (!_doVisibilityChecks) exitWith { [ true, objNull ] };

private _unitsInVisibleRange = _unitsNearPosIndexes apply { _blockingUnits # _x };

private _unitWithVisibilityIndex = _unitsInVisibleRange findIf {lineIntersectsSurfaces [eyePos _x, _posASL, _x] isEqualTo []};

if (_unitWithVisibilityIndex > -1) exitWith {
    [ false, _unitsInVisibleRange # _unitWithVisibilityIndex ]
};

[ true, objNull ]
