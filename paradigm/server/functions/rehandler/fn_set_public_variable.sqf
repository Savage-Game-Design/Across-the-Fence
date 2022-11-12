/*
	File: fn_set_public_variable.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Set a variable in the namespace safely, to avoid the client being able to overwrite arbitrary values
	
	Parameter(s):
		_namespace - Namespace to set the variable in [NAMESPACE]
		_varName - Var name to set [STRING]
		_value - Value to set variable to. Can be anything except code. [ANY]
	
	Returns:
		None
	
	Example(s):
		//Sets para_public_test to 3 on the passed in group.
		["set_public_variable", [_group, "test", 3]] call para_c_fnc_call_on_server;
*/

params ["_namespace", "_varName", "_value"];

if (_value isEqualType {}) exitWith {};

private _safeVarName = format ["para_public_%1", _varName];

_namespace setVariable [_safeVarName, _value, true];