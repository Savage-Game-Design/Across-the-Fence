/*
    File: fn_stealth_setVisibleForDurationAfterDelay.sqf
    Author: Savage Game Design
    Date: 2025-01-22
    Last Update: 2025-01-22
    Public: Yes

    Description:
        Sets the player visible for a specified length of time, after a delay.

        Subsequent calls will use the shortest delay, and the longest duration.
        The idea behind this is the player can get less stealthy, but not more.

    Parameter(s):
        _delaySeconds - Delay to wait for [NUMBER]
        _durationSeconds - Length of time for the player to remain visible in seconds [NUMBER]

    Returns:
        Nothing

    Example(s):
        // Sets the player visible for a period of time, after a delay.
        [5, 10] call vgm_c_fnc_stealth_setVisibleForDurationAfterDelay;
 */

params ["_delaySeconds", "_durationSeconds"];

private _startTime = time + _delaySeconds;

if (isNil "vgm_c_stealth_visibleIn") exitWith {
    vgm_c_stealth_visibleIn = [_startTime, _durationSeconds];
};

vgm_c_stealth_visibleIn params ["_existingStartTime", "_existingDuration"];

vgm_c_stealth_visibleIn = [
    _startTime min _existingStartTime,
    _durationSeconds max _existingDuration
];
