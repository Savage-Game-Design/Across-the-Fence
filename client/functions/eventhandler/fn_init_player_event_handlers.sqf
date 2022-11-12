/*
	File: fn_init_player_event_handlers.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Sets up player event handlers.

	Parameter(s): none

	Returns: nothing

	Example(s):
		call para_c_fnc_init_player_event_handlers;
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
		private _file = preprocessFile format["eventhandlers\player\eh_%1.sqf",_name];
		private _id = player addEventHandler  [_name,_file];
	};
} forEach (configProperties [missionConfigFile >> "gamemode" >> "playerEventHandler"]);
