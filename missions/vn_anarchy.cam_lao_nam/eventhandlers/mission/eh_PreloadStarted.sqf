/*
    File: eh_PreloadStarted.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-05-27
    Last Update: 2020-05-27
    Public: No

    Description:
	    Preload started event handler with self destruct.

    Parameter(s): none

    Returns: nothing

    Example(s):
	    Not called directly.
*/

["PreloadStarted mEH: %1", _this] call BIS_fnc_logFormat;

// self destruct EH
removeMissionEventHandler ["PreloadStarted",_thisEventHandler ];
