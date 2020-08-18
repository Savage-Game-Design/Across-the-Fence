/*
    File: eh_KeyDown.sqf
    Author: Aaron Clark <vbawol>
    Date: 2020-01-29
    Last Update: 2020-05-27
    Public: No

    Description:
		Key down handler.

    Parameter(s):
		_displayorcontrol - Description [DISPLAY|CONTROL]
		_dikcode - Description [NUMBER]
		_shift - Description [BOOL]
		_ctrl - Description [BOOL]
		_alt - Description [BOOL]

    Returns:
		true/false based on if key was handled [BOOL]

    Example(s):
		Not called directly.
*/
_this call para_c_fnc_eh_key_down
