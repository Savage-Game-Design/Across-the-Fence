/*
    File: eh_MapSingleClick.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-05-27
    Last Update: 2020-05-27
    Public: No

    Description:
		MapSingleClick event handler.

    Parameter(s):
		_units - leader selected units, same as groupSelectedUnits [ARRAY]
		_pos - world Position3D of the click in format [x,y,0] [ARRAY]
		_alt - true if Alt key was pressed [BOOL]
		_shift - true if Shift key was pressed [BOOL]

    Returns: nothing

    Example(s):
		Not called directly.
*/

params
[
	"_units",
	"_pos",
	"_alt",
	"_shift"
];

["MapSingleClick mEH: %1", _this] call BIS_fnc_logFormat;
