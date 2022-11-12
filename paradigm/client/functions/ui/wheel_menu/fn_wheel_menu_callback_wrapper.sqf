/*
	File: fn_wheel_menu_callback_wrapper.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Wrapper that makes it easier to call functions from the wheel menu.
		Evaluates arguments at execution time, if it's a script, and removes unnecessary extra args.
	
	Parameter(s):
		_ignore - Passed from wheel menu, not used [ANY]
		_toCall - Consists of three elements - Target action is on, arguments for the nested function, and the function itself. [ARRAY]
	
	Returns:
		Return value of the called function [ANY]
	
	Example(s):
		[parameter] call vn_fnc_myFunction
*/

params ["_ignore", "_toCall"];
_toCall params ["_target", "_args", "_func", "_condition"];

_args = if (_args isEqualType {}) then {_target call _args} else {_args};
_func = if (_func isEqualType "") then {missionNamespace getVariable _func} else {_func};

if (_func isEqualTo {}) then {systemChat format ["Wheel Menu Warning: Function %1 does not exist", _function]};

_args call _func