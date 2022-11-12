/*
	File: fn_load_interop_functions.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Loads interop functions from the mission file, making them available to Paradigm.

		We load from config as a security measure - the mission explicitly enables the interop functions.
		Therefore it should have compileFinal'd implementations of them.
	
	Parameter(s):
		None
	
	Returns:
		None
	
	Example(s):
		class ParadigmInteropFunctions
		{
			my_function = "mytag_fnc_myfunc";
		};

		//To call

		[x, y, z] call para_interop_fnc_my_function;
*/
private _configFile = call para_g_fnc_paradigm_config_file;
private _requiredInteropFunctions = configProperties [_configFile >> "ParadigmInteropFunctionDeclarations"];

//This is the function we use if there's no implementation in the mission, and no default set.
private _notFoundFunction = "
	private	_warningMessage = 'Paradigm: WARNING - Interop function %1 called, but has no definition';
	diag_log _warningMessage;
	[_warningMessage] remoteExec ['systemChat', 0];
";

{
	private _name = configName _x;
	private _defaultFunctionName = getText (_x);
	private _missionFunctionName = getText (missionConfigFile >> "ParadigmInteropFunctions" >> _name);

	private _function = missionNamespace getVariable [
		_missionFunctionName, 
		missionNamespace getVariable [
			_defaultFunctionName,
			compileFinal format [_notFoundFunction, _name]
		]
	];

	missionNamespace setVariable [format ["para_interop_fnc_%1", _name], _function];
} forEach _requiredInteropFunctions;