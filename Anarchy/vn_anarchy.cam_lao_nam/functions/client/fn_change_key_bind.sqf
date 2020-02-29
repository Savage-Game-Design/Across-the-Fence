/*
  Author: Aaron Clark

  Description:
	Change Key Bind

  Example Usage:
	[""] call vn_mf_fnc_change_key_bind;

  Parameter(s):
*/
params [
	["_action","",[""]],  // string
	["_key",0,[0]] // number
];

// todo - unset old key changes but does not remove old keybind
private _old_key = profileNamespace getVariable [_action,-1];
if !(_old_key isEqualTo -1) then
{
	missionNamespace setVariable [format["vn_mf_fnc_key_%1",_old_key],nil];
	missionNamespace setVariable [format["vn_mf_fnc_key_up_%1",_old_key],nil];
};

// set new key
profileNamespace setVariable [_action,_key];



// reinit keys mapping
call vn_mf_fnc_init_key_down;
call vn_mf_fnc_init_key_up;
