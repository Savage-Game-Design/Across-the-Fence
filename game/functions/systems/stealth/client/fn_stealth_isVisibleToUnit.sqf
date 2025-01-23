#include "script_component.inc"
/*
    File: fn_stealth_isVisibleToUnit.sqf
    Author: Savage Game Design
    Date: 2025-01-19
    Last Update: 2025-01-23
    Public: Yes

    Description:
        Checks if the player is visible to the given unit

    Parameter(s):
        _unit - Unit to run visibility checks on [UNIT]

    Returns:
        [_isVisible, _visibility, _spotThreshold] [BOOLEAN, NUMBER, NUMBER] [ARRAY]

    Example(s):
        [allUnits # 0] call vgm_c_fnc_stealth_isVisibleToUnit;
 */

// The range at which you need to be fully visible to be spotted
#define MAX_VISIBILITY_NEEDED_DISTANCE 200
// The absolute minimum visibility to be seen. Should be tested in-game to find the best feeling value.
// 0.333 is two points (e.g head + hand) visible, so should be the minimum
#define BASE_MIN_SPOT_VISIBILITY 0.3
#define MOVEMENT_SPEED_MODIFIER 0.4
#define PERIPHERAL_MAX_PENALTY 0.7
#define DARKNESS_CONSTANT 0.15
#define DARKNESS_SCALING 1

params ["_unit"];

[_unit] call vgm_c_fnc_stealth_getVisibilityForUnit params ["_visibility", "_angleFromEyeline"];


// It gets harder to spot the player based on distance. This scales the minimum visibility needed with distance.
private _distance = player distance _unit;
// Alters the minimum spot visibility to account for players being prone/crouched being harder to see from far away
private _stanceFactor = vgm_c_stealth_stanceMultipliers get stance player;
// Adjust for people being less observant at their peripherals.
private _peripheralAdjustmentFactor = linearConversion [PERIPHERAL_START_ANGLE, VISION_CONE_ANGLE, _angleFromEyeline, 0, PERIPHERAL_MAX_PENALTY, true];
// Adjust for player's movement speed
// 0.5 - Crawl
// 1 - Fast crawl
// 1 - Crouch walk
// 1 - Normal walk
// 2 - Gun up, crouched
// 2.5 - Gun down, crouched
// 3.0 - Jog, gun up
// 3.8 - Jog, gun down
// 4.3 - All sprinting
private _playerSpeed = vectorMagnitude velocity player;
// Speed > 0 will include rotation too - only get full stealth if you're perfectly still.
private _movementSpeedFactor = if (_playerSpeed <= 0.0001 && vgm_c_stealth_rotationalVelocity == 0) then {0} else { linearConversion [0, 4, _playerSpeed, 0.5, 1, true] };
// Lighting influence is inverted - as want to increase minimum required visibility when it's dark.
private _darkness = 1 - ([] call vgm_c_fnc_stealth_getLighting);

private _minSpotVisibility = (
    BASE_MIN_SPOT_VISIBILITY
    + MOVEMENT_SPEED_MODIFIER * (1 - _movementSpeedFactor)
    + _peripheralAdjustmentFactor
    + DARKNESS_CONSTANT * _darkness
    + (_distance * _stanceFactor * (1 + DARKNESS_SCALING * _darkness) / MAX_VISIBILITY_NEEDED_DISTANCE)
);

// Player isn't visible enough to the unit, they can't be seen.
// < is important, as minSpotVisibility could be 1, and _visibility could be 1
private _isVisible = 0 < _visibility && _minSpotVisibility <= _visibility;
private _result = [_isVisible, _visibility, _minSpotVisibility];

#ifdef __A3_DEBUG__
    _unit setVariable ["vgm_c_stealth_visibleResults", _result];
#endif

_result
