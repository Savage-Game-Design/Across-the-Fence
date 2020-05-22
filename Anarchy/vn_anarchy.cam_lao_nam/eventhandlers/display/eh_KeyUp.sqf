/*
  Author: Aaron Clark

  Description:
	Key up handler

  Example Usage:
	call vn_an_fnc_keyup;

  Parameter(s):
*/
params [
	"_displayorcontrol",
	"_dikcode",
	"_shift",
	"_ctrl",
	"_alt"
];

// lookup function to call for key pressed
private _fnc_name = missionNamespace getVariable [format["vn_an_fnc_key_up_%1",_dikcode],""];
if !(_fnc_name isEqualTo "") then
{
	private _fnc = missionNamespace getVariable [_fnc_name,{}];
	// call function for key pressed
	// systemChat format["up %1 = %2",_fnc_name,_fnc];
	if !(_fnc isEqualTo {}) then _fnc;
};
