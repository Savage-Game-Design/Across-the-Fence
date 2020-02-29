/*
  Author: Aaron Clark

  Description:
	returns value for specified key based on gamemode config.

  Example Usage:
	["difficulty", "aiskill", 0.1] call vn_mf_fnc_get_gamemode_value;

  Returns:
	NUMBER, STRING, ARRAY, BOOL

  Parameter(s):
*/
params [
	"_cfg", // 0: STRING - name of config sub class in gamemode
	"_key", // 1: STRING - name of select variable
	"_default" // 2: NUMBER, STRING, ARRAY, BOOL - default value
];

private _config = (missionConfigFile >> "gamemode" >> _cfg);

if (!isClass _config) exitWith
{
	diag_log "DEBUG: Class not found in gamemode config";
};

// get value for selected difficulty
if (_cfg isEqualTo "difficulty") then
{
	_config = _config >> getText(_config >> "setting");
};


private _data = switch (typeName _default) do {
	case "SCALAR":
	{
		if (isNumber (_config)) then
		{
			getNumber _config
		}
		else
		{
			_default
		}
	};
	case "BOOL":
	{
		if (isText (_config)) then
		{
			(getText _config) isEqualTo "true"
		}
		else
		{
			if (isNumber (_config)) then
			{
				(getNumber _config) isEqualTo 1
			}
			else
			{
				_default
			}
		}
	};
	case "ARRAY":
	{
		if (isArray (_config)) then
		{
			getArray _config
		}
		else
		{
			_default
		}
	};
	case "STRING":
	{
		if (isText (_config)) then
		{
			getText _config
		}
		else
		{
			_default
		}
	};
	default
	{
		_default
	};
};
_data
