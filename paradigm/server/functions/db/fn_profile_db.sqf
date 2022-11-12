/*
    File: fn_profile_db.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        Simple profileNamespace key value database concept.

    Parameter(s):
        _mode - GET, TTL, GETARR, SET, SETARR, EXPIRE, DEL, LIST, CLEAR, SAVE, or TTLCHECK [String, defaults to "HELP"]
		_keyName - Name of the value you want to get [String, defaults to "HELP"]
		_data - Data index [String, defaults to "" (empty string)]
		_var1 - Data value [String, defaults to -1]

    Returns:
        Depends on the _mode [ANY]
			- GET: [_ttl, _data] for variable with keyname [Array]
				_ttl: Time-to-Live [Scalar]
				_data: Data [Any]
			- TTL: Time-to-Live [Scalar]
			- GETARR: Data from specified index [Any]
			- SET: [_ttl, _data] for variable with keyname [Array]
				_ttl: Time-to-Live [Scalar]
				_data: Data [Any]
			- SETARR: [_ttl, _data] for variable with keyname at a given array index [Array]
				_ttl: Time-to-Live [Scalar]
				_data: Data [Any]
			- EXPIRE: Doesn't return anything [Nothing]
			- DEL: Doesn't return anything [Nothing]
			- LIST: [_n] of variables matching the prefix [Array]
				_n: Variable name [String]
			- CLEAR: Doesn't return anything [Nothing]
			- SAVE: Doesn't return anything [Nothing]
			- TTLCHECK: Doesn't return anything [Nothing]

    Example(s):
        ["GET", "test_key", "default"] call para_s_fnc_profile_db; - returns ARRAY [ttl,data] for variable with keyname.
		["TTL", "test_key"] call para_s_fnc_profile_db; - returns ttl for variable with keyname SCALAR.
		["GETARR", "test_key", 0] call para_s_fnc_profile_db; - returns ANY data from array at specified index.
		["SET", "test_key", "testing 1234"] call para_s_fnc_profile_db; - Sets data and ttl for variable with keyname and returns ARRAY [ttl,data]
		["SETARR", "test_key", 0, "testing 1234"] call para_s_fnc_profile_db; - Sets data for variable with keyname at a given array index and returns ARRAY [ttl,data]
		["EXPIRE", "test_key", 999] call para_s_fnc_profile_db; - sets ttl for given variable with keyname and returns NOTHING.
		["DEL", "test_key"] call para_s_fnc_profile_db; - removes variable with given keyname returns NOTHING.
		["LIST"] call para_s_fnc_profile_db; - list all variables that match prefix returns ARRAY.
		["CLEAR"] call para_s_fnc_profile_db; - Removes all variables that match prefix returns NOTHING.
		["SAVE"] call para_s_fnc_profile_db; - Force save, returns NOTHING.
		["TTLCHECK"] call para_s_fnc_profile_db; - Loop though all variables that match prefix and remove expired variables.
*/

params [["_mode","HELP"],["_keyName","HELP"],["_data",""],["_var1",-1]];

// database prefix - allow overloading this via missionConfigFile
_prefix = "para_db_";
_config_prefix = getText(missionConfigFile >> "gamemode" >> "settings" >> "dbprefix");
if !(_config_prefix isEqualTo "") then
{
	_prefix = _config_prefix;
};

// To avoid damaging old saves when this only ran on cam_lao_nam
private _worldName = [worldName + "_", ""] select ( worldName isEqualTo "cam_lao_nam" );

// format final variable keyname from prefix and keyname
_finalKeyName = _prefix + _worldName + _keyName;

_allVariables = (parsingNamespace getVariable ["allProfileNamespaceVars",[]]) select {_x find _prefix == 0};

// mode selector
switch (_mode) do
{

	// ["GET", "test_key", "default"] call para_s_fnc_profile_db; - returns ARRAY [ttl,data] for variable with keyname.
	case ("GET"):
	{
		profileNamespace getVariable [_finalKeyName,[_var1,_data]]
	};
	// ["TTL", "test_key"] call para_s_fnc_profile_db; - returns ttl for variable with keyname SCALAR.
	case ("TTL"):
	{
		(profileNamespace getVariable [_finalKeyName,_var1]) params ["_ttl_db","_data_db"];
		_ttl_db
	};
	// ["GETARR", "test_key", 0] call para_s_fnc_profile_db; - returns ANY data from array at specified index.
	case ("GETARR"):
	{
		(profileNamespace getVariable [_finalKeyName,_data]) params ["_ttl_db","_data_db"];
		_data_db select _data
	};
	// ["SET", "test_key", "testing 1234"] call para_s_fnc_profile_db; - Sets data and ttl for variable with keyname and returns ARRAY [ttl,data]
	case ("SET"):
	{
		profileNamespace setVariable [_finalKeyName,[_var1,_data]];
		_allVariables pushBackUnique _finalKeyName;
		parsingNamespace setVariable ["allProfileNamespaceVars",_allVariables];
		profileNamespace getVariable _finalKeyName
	};
	// ["SETARR", "test_key", 0, "testing 1234"] call para_s_fnc_profile_db; - Sets data for variable with keyname at a given array index and returns ARRAY [ttl,data]
	case ("SETARR"):
	{
		(profileNamespace getVariable _finalKeyName) params [["_ttl_db",-1],["_data_db",[]]];
		_data_db set [_data, _var1];
		profileNamespace setVariable [_finalKeyName,[_ttl_db,_data_db]];
		_allVariables pushBackUnique _finalKeyName;
		parsingNamespace setVariable ["allProfileNamespaceVars",_allVariables];
		[_ttl_db,_data_db]
	};
	// ["EXPIRE", "test_key", 999] call para_s_fnc_profile_db; - sets ttl for given variable with keyname and returns NOTHING.
	case ("EXPIRE"):
	{
		(profileNamespace getVariable _finalKeyName) params [["_ttl_db",-1],["_data_db",""]];
		profileNamespace setVariable [_finalKeyName,[_data,_data_db]];
	};
	// ["DEL", "test_key"] call para_s_fnc_profile_db; - removes variable with given keyname returns NOTHING.
	case ("DEL"):
	{
		profileNamespace setVariable [_finalKeyName,nil];
		_allVariables = _allVariables - [_finalKeyName];
		parsingNamespace setVariable ["allProfileNamespaceVars",_allVariables];
	};
	// ["LIST"] call para_s_fnc_profile_db; - list all variables that match prefix returns ARRAY.
	case ("LIST"):
	{
		_allVariables
	};
	// ["CLEAR"] call para_s_fnc_profile_db; - Removes all variables that match prefix returns NOTHING.
	case ("CLEAR"):
	{
		{
			profileNamespace setVariable [_x,nil];
		} forEach _allVariables;
		parsingNamespace setVariable ["allProfileNamespaceVars",[]];
	};
	// ["SAVE"] call para_s_fnc_profile_db; - Force save, returns NOTHING.
	case ("SAVE"):
	{
		saveProfileNamespace
	};
	// ["TTLCHECK"] call para_s_fnc_profile_db; - Loop though all variables that match prefix and remove expired variables.
	case ("TTLCHECK"):
	{
		{
			(profileNamespace getVariable _x) params [["_ttl_db",-1],["_data_db",""]];
			if !(_ttl_db isEqualTo -1) then
			{
				if (_ttl_db >= para_g_totalgametime) then
				{
					profileNamespace setVariable [_x,nil];
					_allVariables = _allVariables - [_x];
				};
			};
		} forEach _allVariables;
		parsingNamespace setVariable ["allProfileNamespaceVars",_allVariables];
	};
	// ERROR
	default
	{
		"Check input"
	};
};
