/*
    File: fn_logInfo.sqf
    Author: Savage Game Design
    Date: 2023-02-26
    Last Update: 2023-12-20
    Public: Yes

    Description:
        Write debug to log file.

    Parameter(s):
        _logLevel - Log level [STRING]
        _message - Message to log [STRING]

    Returns:
        Something [BOOL]

    Example(s):
        "debug data" call vgm_g_fnc_logDebug;
 */

params ["_message"];

["DEBUG", _message] call vgm_g_fnc_log;

