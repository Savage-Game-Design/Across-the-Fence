/*
    File: fn_loading_tickerDots.sqf
    Author: Savage Game Design
    Date: 2023-09-15
    Last Update: 2023-09-15
    Public: No

    Description:
        Return dots string for loading screen.

    Parameter(s):
        Nothing

    Returns:
        Dots string [STRING]

    Example(s):
        [] call vgm_c_fnc_loading_tickerDots
 */

#define DOTS_COUNT 3

private _dots = [];
_dots resize DOTS_COUNT;
{
	if (_forEachIndex < (diag_tickTime % DOTS_COUNT)) then {
		_dots set [_forEachIndex, "."];
	} else {
		_dots set [_forEachIndex, " "];
	};
} forEach _dots;

_dots joinString "" // return
