/*
    File: fn_timeOfDayVote_setTime.sqf
    Author: Savage Game Design
    Date: 2025-11-08
    Last Update: 2025-11-08
    Public: No

    Description:
        Sets the time to the next one that matches the given hour, with a transition.

    Parameter(s):
        _hour - Hour to set time of day to [NUMBER]

    Returns:
        Nothing

    Example(s):
        [18] call vgm_s_fnc_timeOfDayVote_setTime;
 */

params ["_hour"];

private _currentDate = date;
private _newDate = +_currentDate;
_newDate set [3, _hour];
_newDate set [4, 00];

if (dateToNumber _newDate < dateToNumber _currentDate) then {
    // Arma processes an hours value above 24 as going into the next day (above 48 would be 2 days, etc).
    _newDate set [3, _hour + 24];
};

[_newDate, true, true] call BIS_fnc_setDate;
