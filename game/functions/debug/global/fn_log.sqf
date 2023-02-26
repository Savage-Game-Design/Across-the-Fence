/*
    File: fn_log.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-02-26
    Public: Yes

    Description:
        Write to log file.

    Parameter(s):
        _logLevel - Log level [STRING]
        _message - Message to log [STRING]

    Returns:
        Nothing

    Example(s):
        ["INFO", "something happended"] call vgm_g_fnc_log
 */

params ["_logLevel", "_message"];

[_logLevel, _message, nil, nil, "VGM"] call para_g_fnc_log;

