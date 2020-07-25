/*
  Author: Aaron Clark

  Description:
	sets up player event handlers

  Example Usage:
	call vn_an_fnc_init_player_event_handlers;

*/
{
	private _files = getArray(_x >> "files");
	private _name = configName _x;
	if !(_files isEqualTo []) then
	{
		private _cmd = "";
		{
			_cmd = _cmd + preprocessFile _x;
		} forEach _files;
		private _id = player addEventHandler [_name,_cmd];
	} else {
		private _file = preprocessFile format["eventHandlers\player\eh_%1.sqf",_name];
		private _id = player addEventHandler  [_name,_file];
	};
} forEach (configProperties [missionConfigFile >> "gamemode" >> "playerEventHandler"]);
