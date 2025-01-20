#include "script_component.inc"
/*
    File: fn_stealth_isVisibleToUnit.sqf
    Author: Savage Game Design
    Date: 2025-01-19
    Last Update: 2025-01-20
    Public: Yes

    Description:
        Checks if the player is visible to the given unit

    Parameter(s):
        _unit - Unit to run visibility checks on [UNIT]

    Returns:
        [_isVisible, _visibility] [BOOLEAN, NUMBER] [ARRAY]

    Example(s):
        [allUnits # 0] call vgm_c_fnc_stealth_isVisibleToUnit;
 */

// The range at which you need to be fully visible to be spotted
#define MAX_VISIBILITY_NEEDED_DISTANCE 200
// The absolute minimum visibility to be seen. Should be tested in-game to find the best feeling value.
// 0.333 is two points (e.g head + hand) visible, so should be the minimum
#define MINIMUM_SPOT_VISIBILITY 0.3

params ["_unit"];

[_unit] call vgm_c_fnc_stealth_getVisibilityForUnit params ["_visibility", "_angleFromEyeline"];


// It gets harder to spot the player based on distance. This scales the minimum visibility needed with distance.
private _distance = player distance _unit;
// Alters the minimum spot visibility to account for players being prone/crouched being harder to see from far away
private _stanceFactor = vgm_c_stealth_stanceMultipliers get stance player;
// Adjust for people being less observant at their peripherals.
private _peripheralAdjustmentFactor = linearConversion [0, VISION_CONE_ANGLE, _angleFromEyeline, 1, 1.2, true];
private _minSpotVisibility = ((MINIMUM_SPOT_VISIBILITY + (_distance * _stanceFactor / MAX_VISIBILITY_NEEDED_DISTANCE)) * _peripheralAdjustmentFactor) min 1;
// Player isn't visible enough to the unit, they can't be seen.
// < is important, as minSpotVisibility could be 1, and _visibility could be 1
private _isVisible = _minSpotVisibility <= _visibility;
private _result = [_isVisible, _visibility];

#ifdef __A3_DEBUG__
    _unit setVariable ["vgm_c_stealth_visibleResults", _result];
#endif

_result
