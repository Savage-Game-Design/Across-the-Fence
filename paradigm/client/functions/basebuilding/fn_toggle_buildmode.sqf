/*
    File: fn_enable_build_mode.sqf
    Author:  Savage Game Design
    Public: No

    Description:
	Enables build mode.

    Parameter(s): none

    Returns: nothing

    Example(s):
	[_class] call para_c_fnc_enable_build_mode;
*/

params ["_class"];

if (isNil "para_l_buildmode") then {
	para_l_buildmode = true;
	createDialog "para_RscDisplayBuildingMenu";
} else {
	closeDialog 2;
	para_l_buildmode = nil;
	para_l_placing = false;
};
