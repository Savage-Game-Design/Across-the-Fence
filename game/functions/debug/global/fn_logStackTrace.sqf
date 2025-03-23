/*
    File: fn_logStackTrace.sqf
    Author:
    Date: 2024-10-30
    Last Update: 2024-10-30
    Public: Yes

    Description:
        Dumps a compressed stack trace to the .rpt

    Parameter(s):
        _logLevel - Level to log at

    Returns:
        Nothing

    Example(s):
        ["ERROR"] call vgm_g_fnc_logStackTrace;
 */

params ["_logLevel"];

private _trace = diag_stackTrace;

private _traceText = _trace apply {format ["%1 (Line %2)", _x # 0, _x # 1]} joinString endl;

[_logLevel, _traceText] call vgm_g_fnc_log;

