/*
    File: fn_stealth_eachFrame.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-01-19
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

#define MAX_DETECTION_DISTANCE 400
#define MIN_SPOT_TIME 1
#define SPOT_TIME_MULTIPLIER_DISTANCE 10

// This assumes the player is on west, and the enemy is east.
// Saves us frames using this, instead of checking in SQF.
#define ENEMY_SOLDIER_BASE_CLASS "SoldierEB"
#define ENEMY_SIDE east

[] call {
    // Could repeatedly check if nobody is nearby, but that's fine - nearEntities is very fast (0.007ms on Spoffy's PC)
    if (vgm_c_stealth_entityCheckQueue isEqualTo [] || vgm_c_stealth_lastEntityScanPos distance2D player > 10) then {
        // Another syntax allows us to do an "alive" check, but it might be stale by the time we process it.
        // Therefore use faster syntax instead.
        vgm_c_stealth_entityCheckQueue = player nearEntities [ENEMY_SOLDIER_BASE_CLASS, MAX_DETECTION_DISTANCE];
        vgm_c_stealth_lastEntityScanPos = getPosATL player;
    };

    if (vgm_c_stealth_entityCheckQueue isEqualTo []) exitWith {};

    private _unitToCheck = vgm_c_stealth_entityCheckQueue deleteAt (count vgm_c_stealth_entityCheckQueue - 1);
    // Unit can't see player, as they're not in a valid state.
    if (!alive _unitToCheck || side _unitToCheck != ENEMY_SIDE) exitWith {
        vgm_c_stealth_looking deleteAt hashValue _unitToCheck;
    };

    ([_unitToCheck] call vgm_c_fnc_stealth_isVisibleToUnit) params ["_isVisible", "_visibility"];

    // Player isn't visible enough to the unit, they can't be seen.
    if !(_isVisible) exitWith {
        vgm_c_stealth_looking deleteAt hashValue _unitToCheck;
    };

    // Player is visible to unit - mark the unit as having started looking for the player at this time.
    // DON'T REPLACE EARLIER SEEN VALUES.
    hint format ["Player spotted by %1", _unitToCheck];
    vgm_c_stealth_looking getOrDefault [hashValue _unitToCheck, [_unitToCheck, time], true];
};

call {
    if (vgm_c_stealth_lookingQueue isEqualTo []) then {
        vgm_c_stealth_lookingQueue = values vgm_c_stealth_looking;
    };

    if (vgm_c_stealth_lookingQueue isEqualTo []) exitWith {};

    (vgm_c_stealth_lookingQueue deleteAt (count vgm_c_stealth_lookingQueue - 1)) params ["_lookingUnit", "_seenAt"];


    private _visibilityCheck = [_lookingUnit] call vgm_c_fnc_stealth_isVisibleToUnit;
    private _isVisible = _visibilityCheck # 0;
    private _visibility = _visibilityCheck # 1;

    if !(alive _lookingUnit && side _lookingUnit == ENEMY_SIDE && _isVisible) exitWith {
        vgm_c_stealth_looking deleteAt hashValue _lookingUnit;
    };

    //1 * (1/x) * max((y+1)/10, 1)

    // Equation for Deimos graphic calc - x is visibility, y is distance in meters.
    // 1 * (1/x) * max((y+1)/10, 1)
    // Maximum spot time with this equation is: MIN_SPOT_TIME * 10 *
    private _distance = player distance _lookingUnit;
    private _spotTime = MIN_SPOT_TIME * ((1 / _visibility) min 10) * ((_distance / SPOT_TIME_MULTIPLIER_DISTANCE) max 1);

    if (_seenAt + _spotTime < time) then {
        // TODO - set duration of visibility
        hint format ["Enemy alerted: %1", _lookingUnit];
        [true] call vgm_c_fnc_stealth_setVisible;
    };
};
