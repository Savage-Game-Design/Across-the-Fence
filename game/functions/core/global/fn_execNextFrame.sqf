/*
    File: fn_execNextFrame.sqf
    Author:
    Date: 2022-12-20
    Last Update: 2023-07-17
    Public: No

    Description:
        Execute code once in a non scheduled environment on a next frame.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [{diag_log [_this, diag_frameNo]}, diag_frameNo] call vgm_g_fnc_execNextFrame
 */

params ["_code", ["_args", []]];

addMissionEventHandler ["EachFrame", {
	_thisArgs params ["_frameNo", "_code", "_args"];
	if (diag_frameNo <= _frameNo) exitWith {};

	_args call _code;

	removeMissionEventHandler [_thisEvent, _thisEventHandler];
}, [diag_frameno, _code, _args]];
