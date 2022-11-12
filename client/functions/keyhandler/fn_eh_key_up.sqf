/*
    File: eh_KeyUp.sqf
    Author:  Savage Game Design
    Public: No

    Description:
	Key down handler.

    Parameter(s):
	_displayorcontrol - Description [DISPLAY|CONTROL]
	_dikcode - Description [NUMBER]
	_shift - Description [BOOL]
	_ctrl - Description [BOOL]
	_alt - Description [BOOL]

    Returns: nothing

    Example(s):
	_this call para_c_fnc_eh_key_up
*/

params
[
	"_displayorcontrol",
	"_dikcode",
	"_shift",
	"_ctrl",
	"_alt"
];

// format var key
private _var_key = ["para_c_fnc_key_up"];
_var_key append [_dikcode,_shift,_ctrl,_alt];

para_keydown_shift = _shift;
para_keydown_ctrl = _ctrl;
para_keydown_alt = _alt;

// lookup function to call for key pressed
private _fnc_name = missionNamespace getVariable [(_var_key joinString "_"),""];
if !(_fnc_name isEqualTo "") then
{
	private _fnc = missionNamespace getVariable [_fnc_name,{}];
	// call function for key pressed
	if !(_fnc isEqualTo {}) then _fnc;
};
