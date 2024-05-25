/*
    File: fn_logError.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-06-27
    Public: Yes

    Description:
        Write error to log file.

    Parameter(s):
        _logLevel - Log level [STRING]
        _message - Message to log [STRING]

    Returns:
        Something [BOOL]

    Example(s):
        "something happended" call vgm_g_fnc_logError
 */

params ["_message"];

["ERROR", _message] call vgm_g_fnc_log;

