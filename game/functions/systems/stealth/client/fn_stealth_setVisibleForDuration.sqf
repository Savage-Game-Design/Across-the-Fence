/*
    File: fn_setVisibleForDuration.sqf
    Author: Savage Game Design
    Date: 2025-01-19
    Last Update: 2025-01-31
    Public: Yes

    Description:
        Sets the player visible for at most the specified length of time.

        Uses the longest time possible. E.g - If a player is set as visible for 30 seconds, another
        call to set them visible for 3 seconds won't override that.

    Parameter(s):
        _durationSeconds - Length of time for the player to remain visible in seconds [NUMBER]

    Returns:
        Nothing

    Example(s):
        [30] call vgm_c_fnc_stealth_setVisibleForDuration
 */

params ["_durationSeconds"];

private _endTime = time + _durationSeconds;
private _currentEndTime = missionNamespace getVariable ["vgm_c_stealth_visibleUntil", 0];

vgm_c_stealth_visibleUntil = _currentEndTime max _endTime;
[true] call vgm_c_fnc_stealth_setVisible;
