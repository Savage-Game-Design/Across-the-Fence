/*
    File: fn_set_local_var.sqf
    Author:  Savage Game Design
    Public: No

    Description:
		Sets local var for an array of data and executes event handler fnc if exists.

    Parameter(s):
		_variables - [_varname, _vardata] [ARRAY, defaults to []]
			_varname - Variable name [String]
			_vardata - Variable value [Any]

    Returns: nothing

    Example(s):
		[[["vn_mf_varname","vardata"],["vn_mf_varname","vardata"]]] remoteExecCall ["para_c_fnc_set_local_var",_player];
*/

params
[
	["_variables",[],[[]]]	// 0 : ARRAY of _variables
];
{
	_x params ["_varname", "_vardata"];
	player setVariable [_varname,_vardata];

	// trigger vars EH code
	_function = getText(missionConfigFile >> "gamemode" >> "vars" >> "tracking" >> _varname >> "script");
	_fnc = missionNamespace getVariable [_function,{}];
	if !(_fnc isEqualTo {}) then
	{
		[_varname,_vardata] call _fnc
	};
} forEach _variables;
