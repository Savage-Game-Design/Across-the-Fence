/*
    File: fn_event_convertEventToHashableEvent.sqf
    Author:
    Date: 2022-12-20
    Last Update: 2022-12-20
    Public: No

    Description:
        Converts an event with any topic into a hashable event (an event with a string topic)
        Idempotent operation - If call this function on its result, the result is unchanged.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params [["_event", nil, [[]], 2]];

if (_event # 1 isEqualType "") exitWith {
    _event + []
};

[_event # 0, hashValue (_event # 1)]
