/*
  Author: Aaron Clark

  Description:
	simple profileNamespace key value database concept

  Example Usage:
	see comments below
*/
params [["_mode","HELP"],["_keyName","HELP"],["_data",""],["_var1",-1]];

// database prefix
_prefix = "vn_mfdb_";

// format final variable keyname from prefix and keyname
_finalKeyName = _prefix + _keyName;

_allVariables = (parsingNamespace getVariable ["allProfileNamespaceVars",[]]) select {_x find _prefix == 0};

// mode selector
switch (_mode) do
{

	// ["GET", "test_key", "default"] call vn_mf_fnc_hive; - returns ARRAY [ttl,data] for variable with keyname.
	case ("GET"):
	{
		profileNamespace getVariable [_finalKeyName,[_var1,_data]]
	};
	// ["TTL", "test_key"] call vn_mf_fnc_hive; - returns ttl for variable with keyname SCALAR.
	case ("TTL"):
	{
		(profileNamespace getVariable [_finalKeyName,_var1]) params ["_ttl_db","_data_db"];
		_ttl_db
	};
	// ["GETARR", "test_key", 0] call vn_mf_fnc_hive; - returns ANY data from array at specified index.
	case ("GETARR"):
	{
		(profileNamespace getVariable [_finalKeyName,_data]) params ["_ttl_db","_data_db"];
		_data_db select _data
	};
	// ["SET", "test_key", "testing 1234"] call vn_mf_fnc_hive; - Sets data and ttl for variable with keyname and returns ARRAY [ttl,data]
	case ("SET"):
	{
		profileNamespace setVariable [_finalKeyName,[_var1,_data]];
		_allVariables pushBackUnique _finalKeyName;
		parsingNamespace setVariable ["allProfileNamespaceVars",_allVariables];
		profileNamespace getVariable _finalKeyName
	};
	// ["SETARR", "test_key", 0, "testing 1234"] call vn_mf_fnc_hive; - Sets data for variable with keyname at a given array index and returns ARRAY [ttl,data]
	case ("SETARR"):
	{
		(profileNamespace getVariable _finalKeyName) params [["_ttl_db",-1],["_data_db",[]]];
		_data_db set [_data, _var1];
		profileNamespace setVariable [_finalKeyName,[_ttl_db,_data_db]];
		_allVariables pushBackUnique _finalKeyName;
		parsingNamespace setVariable ["allProfileNamespaceVars",_allVariables];
		[_ttl_db,_data_db]
	};
	// ["EXPIRE", "test_key", 999] call vn_mf_fnc_hive; - sets ttl for given variable with keyname and returns NOTHING.
	case ("EXPIRE"):
	{
		(profileNamespace getVariable _finalKeyName) params [["_ttl_db",-1],["_data_db",""]];
		profileNamespace setVariable [_finalKeyName,[_data,_data_db]];
	};
	// ["DEL", "test_key"] call vn_mf_fnc_hive; - removes variable with given keyname returns NOTHING.
	case ("DEL"):
	{
		profileNamespace setVariable [_finalKeyName,nil];
		_allVariables = _allVariables - [_finalKeyName];
		parsingNamespace setVariable ["allProfileNamespaceVars",_allVariables];
	};
	// ["LIST"] call vn_mf_fnc_hive; - list all variables that match prefix returns ARRAY.
	case ("LIST"):
	{
		_allVariables
	};
	// ["CLEAR"] call vn_mf_fnc_hive; - Removes all variables that match prefix returns NOTHING.
	case ("CLEAR"):
	{
		{
			profileNamespace setVariable [_x,nil];
		} forEach _allVariables;
		parsingNamespace setVariable ["allProfileNamespaceVars",[]];
	};
	// ["SAVE"] call vn_mf_fnc_hive; - Force save, returns NOTHING.
	case ("SAVE"):
	{
		saveProfileNamespace
	};
	// ["TTLCHECK"] call vn_mf_fnc_hive; - Loop though all variables that match prefix and remove expired variables.
	case ("TTLCHECK"):
	{
		{
			(profileNamespace getVariable _x) params [["_ttl_db",-1],["_data_db",""]];
			if !(_ttl_db isEqualTo -1) then
			{
				if (_ttl_db >= vn_mf_totalgametime) then
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
