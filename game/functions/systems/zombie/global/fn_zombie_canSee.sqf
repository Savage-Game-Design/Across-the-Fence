/*
    File: fn_zombie_canSee.sqf
    Author: Savage Game Design
    Date: 2025-10-20
    Last Update: 2025-10-29
    Public: No

    Description:
        Is the target perceivable by the zombie (visual, hearing), with the given vision range?

    Parameter(s):
        _zombie - Unit to use [UNIT]
        _target - Target to check if visible [UNIT]
        _range - Vision range of the zombie [NUMBER]


    Returns:
        True if the target is perceivable by the zombie [BOOL]

    Example(s):
        [cursorObject, player, 100] call vgm_g_fnc_zombie_canSee;
 */

params ["_zombie", "_target", "_range"];

if !(isNull objectParent _target) exitWith {
    isEngineOn (vehicle _target) || {[_zombie, vehicle _target] call BIS_fnc_isInFrontOf}
};

private _dist = _zombie distance _target;
private _targetSpeed = abs speed _target;

// Only crawling is safe
if (_dist < 5 && _targetSpeed > 4) exitWith { true };

// Walking is safe
if (_dist < 10 && _targetSpeed > 7) exitWith { true };

// Everything but sprinting is safe
if (_dist < 20 && _targetSpeed > 15) exitWith { true };

if !([_zombie, _target] call BIS_fnc_isInFrontOf) exitWith { false };

_target isFlashlightOn (currentWeapon _target) && {_dist < (_range * 1.5)} ||
    {
        private _targetEyepos = eyepos _target;
        /*
        private _visibleRange = switch (stance _target) do {
            case "CROUCH": {_range * 0.75};
            case "PRONE": {_range * 0.4};
            default {_range};
        };
        */
        private _visibleRange = _range;

        _dist < _visibleRange &&
        {_targetEyepos select 2 > -0.2} &&
        {[_zombie, "IFIRE", _target] checkVisibility [eyepos _zombie, _targetEyepos] > 0.2};
    }
