/*
  Author: Aaron Clark

  Description:
	Spawns object and loads related data

  Example Usage:
	call vn_an_fnc_spawn_objects;

  Parameter(s):
	NA

  Returns:
	NOTHING

*/
{
	//code
	_configname = configName _x;

	(["GET", (_configname + "_data"), []] call vn_an_fnc_hive) params ["","_object_data"];
	_class = getText (_x >> "classname");
	_removed = false;

	{
		_x params ["_varname","_vardata"];
		if (_varname isEqualTo "vn_an_buildclass") then
		{
			_class = _vardata
		};
		if (_varname isEqualTo "removed") then
		{
			_removed = _vardata
		};
	} forEach _object_data;

	if !(_removed) then
	{

		//diag_log ("DEBUG: " + str [(_configname + "_data"),_object_data]);

		_pos = getArray (_x >> "posWorld");
		_postype = "world";
		_vectordir = getArray (_x >> "dir");
		_vectorUp = getArray (_x >> "up");

		_randompos = getArray (_x >> "randomPos");
		if !(_randompos isEqualTo []) then
		{
			// diag_log ("DEBUG: " + str [_randompos]);
			_pos = _randompos call BIS_fnc_randomPos;
			_postype = "ATL";
		};



		_object = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];

		missionNamespace setVariable [_configname, _object];
		_object setVehicleVarName _configname;

		// load latest class

		if !(_object_data isEqualTo []) then
		{
			{
			_x params ["_varname","_vardata"];
			_object setVariable [_varname,_vardata];
			} forEach _object_data;
		};


		switch (_postype) do
		{
			case ("world"):
			{
				_object setVectorDirAndUp [_vectordir,_vectorUp];
				_object setPosWorld _pos;
			};
			case ("ATL"):
			{
				// _object setVectorDirAndUp [_vectordir,_vectorUp];
				_object setPosATL _pos;
			};
		};


	};

} forEach (configProperties [missionConfigFile >> "gamemode" >> "objects"]);
