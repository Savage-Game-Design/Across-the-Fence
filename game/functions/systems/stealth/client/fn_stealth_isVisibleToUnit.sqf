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
#define MINIMUM_SPOT_VISIBILITY 0.17

params ["_unit"];

private _visibility = [_unit] call vgm_c_fnc_stealth_getVisibilityForUnit;

// It gets harder to spot the player based on distance. This scales the minimum visibility needed with distance.
private _distance = player distance _unit;
private _minSpotVisibility = (MINIMUM_SPOT_VISIBILITY + (_distance / MAX_VISIBILITY_NEEDED_DISTANCE)) min 1;

// Player isn't visible enough to the unit, they can't be seen.
// < is important, as minSpotVisibility could be 1, and _visibility could be 1
[_minSpotVisibility <= _visibility, _visibility]
