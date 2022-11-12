/*
    File: fn_change_key_bind.sqf
    Author:  Savage Game Design
    Public: No

    Description:
	Changes Key Binds.

    Parameter(s):
	_action - name of action from keys.hpp [STRING, defaults to "", requires string]
	_key - DIK_KeyCode integer [NUMBER, defaults to 0, requires number]
	_shift - Shift State [BOOL, defaults to false]
	_ctrl - Ctrl State [BOOL, defaults to false]
	_alt - Alt State [BOOL, defaults to false]

    Returns: nothing

    Example(s):
	["para_keydown_enable_selector",6,false,false,false] call para_c_fnc_change_key_bind;
*/

params
[
	["_action","",[""]],  // string
	["_key",0,[0]], // number
	["_shift",false], // bool
	["_ctrl",false], // bool
	["_alt",false] // bool
];

// remove old key bind
private _old_key_data = profileNamespace getVariable [_action,[]];
if !(_old_key_data isEqualType []) then {_old_key_data = []};
if !(_old_key_data isEqualTo []) then
{
	private _var_key = ["para_c_fnc_key"];
	private _var_key_up = ["para_c_fnc_key_up"];
	_var_key append _old_key_data;
	_var_key_up append _old_key_data;
	missionNamespace setVariable [(_var_key joinString "_"),nil];
	missionNamespace setVariable [(_var_key_up joinString "_"),nil];
};

// set new key
profileNamespace setVariable [_action,[_key,_shift,_ctrl,_alt]];

// reinit keys mapping
call para_c_fnc_init_key_down;
call para_c_fnc_init_key_up;
