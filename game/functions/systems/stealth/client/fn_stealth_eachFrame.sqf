#include "script_component.inc"
/*
    File: fn_stealth_eachFrame.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-08-24
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
#define MAX_SUSPICION 1
#define LINGERING_SUSPICION_DECAY_PER_SECOND 0.02
#define LINGERING_SUSPICION_FRACTION 0.35
#define SUSPICION_DECAY_PER_SECOND 0.2

// Manually calculate the player's rotatonal velocity
private _changeInAngle = abs (getDir player - vgm_c_stealth_lastDir);
vgm_c_stealth_lastDir = getDir player;
// This can happen early on, when the handler is first attached.
if (diag_deltaTime > 0) then {
    vgm_c_stealth_rotationalVelocity = _changeInAngle / diag_deltaTime;
};

if (!isNil "vgm_c_stealth_visibleUntil" && { vgm_c_stealth_visibleUntil < time }) then {
    [false] call vgm_c_fnc_stealth_setVisible;
};

// Make the player visible *after* we make them hidden, if necessary.
// Delayed visibility takes priority over re-hiding the player, otherwise they
// might get away with doing something that should make them visible.
if (!isNil "vgm_c_stealth_visibleAt" && { vgm_c_stealth_visibleAt # 0 < time }) then {
    [vgm_c_stealth_visibleAt # 1] call vgm_c_fnc_stealth_setVisibleForDuration;
    vgm_c_stealth_visibleAt = nil;
};

call {
    // Could repeatedly check if nobody is nearby, but that's fine - nearEntities is very fast (0.007ms on Spoffy's PC)
    if (vgm_c_stealth_entityCheckQueue isEqualTo [] || vgm_c_stealth_lastEntityQueueScanPos distance2D player > 40) then {
        // Another syntax allows us to do an "alive" check, but it might be stale by the time we process it.
        // Therefore use faster syntax instead.
        vgm_c_stealth_entityCheckQueue = player nearEntities [ENEMY_SOLDIER_BASE_CLASS, MAX_DETECTION_DISTANCE];
        vgm_c_stealth_lastEntityQueueScanPos = getPosATL player;
    };

    if (vgm_c_stealth_entityCheckQueue isEqualTo []) exitWith {};

    private _unitToCheck = vgm_c_stealth_entityCheckQueue deleteAt 0;
    // Unit can't see player, as they're not in a valid state.
    if (!alive _unitToCheck || side _unitToCheck != ENEMY_SIDE) exitWith {};

    // Player can't be seen by anyone, due to being undetectable
    if (vgm_c_stealth_undetectable) exitWith {};

    ([_unitToCheck] call vgm_c_fnc_stealth_isVisibleToUnit) params ["_isVisible", "_visibility"];

    // Player isn't visible enough to the unit, they can't be seen.
    if !(_isVisible) exitWith {};

    // Player is visible to unit - mark the unit as having started looking for the player at this time.
    // DON'T REPLACE EARLIER SEEN VALUES.
    vgm_c_stealth_looking getOrDefault [hashValue _unitToCheck, [_unitToCheck, time], true];
};

call {
    if (vgm_c_stealth_lookingQueue isEqualTo []) then {
        // Need the key for deletion, as deleted units have their hashValue changed.
        vgm_c_stealth_lookingQueue = vgm_c_stealth_looking toArray false;
    };

    if (vgm_c_stealth_lookingQueue isEqualTo []) exitWith {};

    (vgm_c_stealth_lookingQueue deleteAt 0) params ["_lookingKey", "_lookingValue"];
    _lookingValue params ["_lookingUnit", "_seenAt"];


    [_lookingUnit] call vgm_c_fnc_stealth_isVisibleToUnit params ["_isVisible", "_visibility"];

    private _unitCanDetectPlayer = alive _lookingUnit && side _lookingUnit == ENEMY_SIDE && _isVisible;
    if (!_unitCanDetectPlayer || vgm_c_stealth_undetectable) exitWith {
        vgm_c_stealth_looking deleteAt _lookingKey;
        #ifdef __A3_DEBUG__
            _lookingUnit setVariable ["vgm_c_stealth_spotTimeDebug", nil];
        #endif
    };

    private _distance = player distance _lookingUnit;
    // How long it should take the AI to spot the player, if they were looking at them continously.
    private _spotTime = (MIN_SPOT_TIME + 2 * (1 - _visibility) + (((_distance - 10) / SPOT_TIME_MULTIPLIER_DISTANCE) max 0)) * (player getVariable ["vgm_stealth_spotTimeMultiplier", 1]);
    // This is converted into "suspicion", to account for AI not looking at the player continuously.
    (vgm_c_stealth_suspicion getOrDefault [hashValue _lookingUnit, [0, 0, _seenAt], true]) params ["_currentSuddenSuspicion", "_currentLingeringSuspicion", "_suspicionLastTicked"];
    private _deltaTime = time - (_suspicionLastTicked max _seenAt);
    private _suspicionIncrease = MAX_SUSPICION * (_deltaTime / _spotTime);
    private _lingeringSuspicionIncrease = _suspicionIncrease * LINGERING_SUSPICION_FRACTION;
    private _suddenSuspicionIncrease = _suspicionIncrease * (1 - LINGERING_SUSPICION_FRACTION);
    private _newLingeringSuspicion = (_currentLingeringSuspicion + _lingeringSuspicionIncrease) min MAX_SUSPICION;
    private _newSuddenSuspicion = (_currentSuddenSuspicion + _suddenSuspicionIncrease) min (MAX_SUSPICION - _newLingeringSuspicion);
    vgm_c_stealth_suspicion set [hashValue _lookingUnit, [
        _newSuddenSuspicion,
        _newLingeringSuspicion,
        time
    ]];

    private _newSuspicion = _newLingeringSuspicion + _newSuddenSuspicion;

    #ifdef __A3_DEBUG__
        _lookingUnit setVariable ["vgm_c_stealth_spotTimeDebug", _spotTime];
    #endif

    if (_newSuspicion >= MAX_SUSPICION) then {
        [vgm_c_stealth_visibleDurationWhenSeen] call vgm_c_fnc_stealth_setVisibleForDuration;
        // Avoid delays in being shot - particularly bad at night, where AI might miss the play, even when visible.
        [_lookingUnit, [player, 2]] remoteExec ["reveal", _lookingUnit];
    };
};

// Decay suspicions every frame. This should never have enough units in it for performance to matter.
{
    private _values = vgm_c_stealth_suspicion get _x;
    private _newSuddenSuspicion = ((_values # 0) - SUSPICION_DECAY_PER_SECOND * diag_deltaTime) max 0;
    private _newLingeringSuspicion = ((_values # 1) - LINGERING_SUSPICION_DECAY_PER_SECOND * diag_deltaTime) max 0;
    private _newSuspicion = _newLingeringSuspicion + _newSuddenSuspicion;
    if (_newSuspicion <= 0) then {
        // Keeps the size of this map small, and clears out dead units too.
        vgm_c_stealth_suspicion deleteAt _x;
    } else {
        _values set [0, _newSuddenSuspicion];
        _values set [1, _newLingeringSuspicion];
    };
} forEach keys vgm_c_stealth_suspicion;
