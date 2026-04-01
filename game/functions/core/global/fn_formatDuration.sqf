/*
    File: fn_formatDuration.sqf
    Author: Savage Game Design
    Date: 2026-02-16
    Last Update: 2026-02-16
    Public: No

    Description:
        Formats a time in seconds as an appropriate string for display

    Parameter(s):
        _duration - Duration in seconds

    Returns:
        Formatted duration [STRING]

    Example(s):
        [300] call vgm_g_fnc_formatDuration;
 */

params ["_duration"];

if (_duration > 3600) exitWith {
    private _hours = floor (_duration / 3600);
    private _minutes = ceil ((_duration - _hours * 3600) / 60);
    format ["%1h %2m", _hours, _minutes]
};

if (_duration > 60) exitWith {
    format ["%1m", ceil (_duration / 60)]
};

format ["%1s", ceil _duration]
