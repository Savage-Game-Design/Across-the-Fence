/*
    File: fn_compile_functions.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Compiles a set of files into functions.
    
    Parameter(s):
		As many arguments as desired, each argument is a function descriptor: A an array with a prefix, and an array of file names. [ARRAY]
    
    Returns:
		None
    
    Example(s):
		[["an_c", "\sgd\test\", ["test.sqf"]]] call para_g_fnc_compile_functions
*/

private _functionDescriptors = _this;

{
	_x params ["_tag", "_prefix", "_files", ["_sendToServer", false]];
	{
		//Trim SQF suffix
		private _functionName = _x select [0, count _x - 4];
		if (_functionName select [0,3] == "fn_") then {
			_functionName = _functionName select [3, count _functionName];
		};
		_functionName = format ["%1_fnc_%2", _tag, _functionName];
		private _path = _prefix + _x;
		missionNamespace setVariable [_functionName, compile preprocessFileLineNumbers _path];
		if (_sendToServer) then {
			publicVariableServer _functionName;
		};
	} forEach _files;
} forEach _functionDescriptors;