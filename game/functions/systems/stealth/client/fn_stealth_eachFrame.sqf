#include "script_component.inc"
/*
    File: fn_stealth_eachFrame.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-01-23
    Public: No

    Description:
        Checks visibility of player for nearby AI, and updates their visibility if spotted.

    Parameter(s):
        None

    Returns:
        Nothing [BOOL]

    Example(s):
        addMissionEventHandler ["EachFrame", vgm_c_fnc_stealth_eachFrame];
 */

#define MIN_SPOT_TIME 0.3
#define SPOT_TIME_MULTIPLIER_DISTANCE 60

// Manually calculate the player's rotatonal velocity
private _changeInAngle = abs (getDir player - vgm_c_stealth_lastDir);
vgm_c_stealth_lastDir = getDir player;
vgm_c_stealth_rotationalVelocity = _changeInAngle / diag_deltaTime;

if (!isNil "vgm_c_stealth_visibleUntil" && { vgm_c_stealth_visibleUntil < time }) then {
    [false] call vgm_c_fnc_stealth_setVisible;
};

// Make the player visible *after* we make them hidden, if necessary.
// Delayed visibility takes priority over re-hiding the player, otherwise they
// might get away with doing something that should make them visible.
if (!isNil "vgm_c_stealth_visibleIn" && { vgm_c_stealth_visibleIn # 0 < time }) then {
    [vgm_c_stealth_visibleIn # 1] call vgm_c_fnc_stealth_setVisibleForDuration;
    vgm_c_stealth_visibleIn = nil;
};

[] call {
    // Could repeatedly check if nobody is nearby, but that's fine - nearEntities is very fast (0.007ms on Spoffy's PC)
    if (vgm_c_stealth_entityCheckQueue isEqualTo [] || vgm_c_stealth_lastEntityQueueScanPos distance2D player > 40) then {
        // Another syntax allows us to do an "alive" check, but it might be stale by the time we process it.
        // Therefore use faster syntax instead.
        vgm_c_stealth_entityCheckQueue = player nearEntities [ENEMY_SOLDIER_BASE_CLASS, MAX_DETECTION_DISTANCE];
        vgm_c_stealth_lastEntityQueueScanPos = getPosATL player;
    };

    if (vgm_c_stealth_entityCheckQueue isEqualTo []) exitWith {};

    private _unitToCheck = vgm_c_stealth_entityCheckQueue deleteAt (count vgm_c_stealth_entityCheckQueue - 1);
    // Unit can't see player, as they're not in a valid state.
    if (!alive _unitToCheck || side _unitToCheck != ENEMY_SIDE) exitWith {};

    ([_unitToCheck] call vgm_c_fnc_stealth_isVisibleToUnit) params ["_isVisible", "_visibility"];

    // Player isn't visible enough to the unit, they can't be seen.
    if !(_isVisible) exitWith {};

    // Player is visible to unit - mark the unit as having started looking for the player at this time.
    // DON'T REPLACE EARLIER SEEN VALUES.
    vgm_c_stealth_looking getOrDefault [hashValue _unitToCheck, [_unitToCheck, time], true];
};

call {
    if (vgm_c_stealth_lookingQueue isEqualTo []) then {
        // Need the key for deletion, as dead units have their hashValue changed.
        vgm_c_stealth_lookingQueue = vgm_c_stealth_looking toArray false;
    };

    if (vgm_c_stealth_lookingQueue isEqualTo []) exitWith {};

    (vgm_c_stealth_lookingQueue deleteAt (count vgm_c_stealth_lookingQueue - 1)) params ["_lookingKey", "_lookingValue"];
    _lookingValue params ["_lookingUnit", "_seenAt"];


    [_lookingUnit] call vgm_c_fnc_stealth_isVisibleToUnit params ["_isVisible", "_visibility"];

    if !(alive _lookingUnit && side _lookingUnit == ENEMY_SIDE && _isVisible) exitWith {
        vgm_c_stealth_looking deleteAt _lookingKey;
        #ifdef __A3_DEBUG__
            _lookingUnit setVariable ["vgm_c_stealth_spotTimeDebug", nil];
        #endif
    };

    //1 * (1/x) * max((y+1)/10, 1)

    // Equation for Deimos graphic calc - x is visibility, y is distance in meters.
    // f(x, y) = 1 * min((1/x), 5) * (1 + (y+1)/SPOT_TIME_MULTIPLIER_DISTANCE )
    private _distance = player distance _lookingUnit;
    private _spotTime = MIN_SPOT_TIME + 2 * (1 - _visibility) + (((_distance - 10) / SPOT_TIME_MULTIPLIER_DISTANCE) max 0);

    #ifdef __A3_DEBUG__
        _lookingUnit setVariable ["vgm_c_stealth_spotTimeDebug", _spotTime];
    #endif

    if (_seenAt + _spotTime < time) then {
        [vgm_c_stealth_visibleDurationWhenSeen] call vgm_c_fnc_stealth_setVisibleForDuration;
    };
};
