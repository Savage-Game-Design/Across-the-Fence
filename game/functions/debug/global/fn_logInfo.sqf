/*
    File: fn_logInfo.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-12-20
    Public: Yes

    Description:
        Write info to log file.

    Parameter(s):
        _logLevel - Log level [STRING]
        _message - Message to log [STRING]

    Returns:
        Something [BOOL]

    Example(s):
        "info message" call vgm_g_fnc_logInfo;
 */

params ["_message"];

["INFO", _message] call vgm_g_fnc_log;

