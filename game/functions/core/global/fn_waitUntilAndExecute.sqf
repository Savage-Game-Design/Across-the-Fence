/*
    File: fn_waitUntilAndExecute.sqf
    Author: Savage Game Design
    Date: 2025-02-02
    Last Update: 2025-02-24
    Public: Yes

    Description:
        Executes provided code unscheduled once the condition is true, optionally can have a timeout and code executed upon the timeout.

    Parameter(s):
        _condition - Callback to call for condition check [CODE]
        _code - Callback to execute once condition is true [CODE]
        _args - Arguments to pass to all callbacks [ANY]
        _timeoutDelay - How long to wait for the timeout [NUMBER]
        _timeoutCode - Callback to call on timeout [CODE]

    Returns:
        Nothing

    Example(s):
        [
            {speed (_this#0) < 1},
            {systemChat "standing still"},
            [player],
            5,
            {systemChat "please stand still!"}
        ] call vgm_g_fnc_waitUntilAndExecute;
 */

params [
    ["_condition", {true}, [{}]],
    ["_code", {}, [{}]],
    ["_args", []],
    ["_timeoutDelay", nil, [0]],
    ["_timeoutCode", {}, [{}]]
];

vgm_core_waitUntilAndExecute_array pushBack [_condition, _code, _args, time + _timeoutDelay, _timeoutCode];

nil
