/*
  Author: Aaron Clark

  Description:
	adds mission event handlers by target scope

  Example Usage:
	_target_scope call vn_mf_fnc_init_mission_handlers;

  Returns:
	NOTHING

  Parameter(s):
*/
params ["_target_scope"];

// init mission EH
{
	if (_target_scope in getArray(_x >> "targets")) then
	{
		private _files = getArray(_x >> "files");
		private _name = configName _x;
		if !(_files isEqualTo []) then
		{
			private _cmd = "";
			{
				_cmd = _cmd + preprocessFile _x;
			} forEach _files;
			private _id = addMissionEventHandler [_name,_cmd];
		} else {
			private _file = preprocessFile format["eventHandlers\mission\eh_%1.sqf",_name];
			private _id = addMissionEventHandler [_name,_file];
		};
	};
} forEach (configProperties [missionConfigFile >> "gamemode" >> "missionEventHandler"]);
