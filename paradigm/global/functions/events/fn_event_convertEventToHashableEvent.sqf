/*
    File: fn_event_convertEventToHashableEvent.sqf
    Author: Savage Game Design
    Date: 2022-12-20
    Last Update: 2023-01-22
    Public: No

    Description:
        Converts an event with any topic into a hashable event (an event with a string topic)
        Idempotent operation - If call this function on its result, the result is unchanged.

    Parameter(s):
        _event - Event to convert to a hashable event, (STRING, ANY) [ARRAY]

    Returns:
        Hashable event (STRING, STRING) [ARRAY]

    Example(s):
        ["eventName", objNull] call para_g_fnc_event_convertEventToHashableEvent;
 */

params [["_event", nil, [[]], 2]];

if (_event # 1 isEqualType "") exitWith {
    _event + []
};

[_event # 0, hashValue (_event # 1)]
