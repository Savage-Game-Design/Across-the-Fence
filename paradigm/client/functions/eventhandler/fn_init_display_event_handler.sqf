/*
	File: fn_init_display_event_handler.sqf
	Author:  Savage Game Design
	Public: No

	Description:
		Sets up displayEventHandler event handlers from gamemode displayEventHandler config.

	Parameter(s): none

	Returns: nothing

	Example(s):
		call para_c_fnc_init_display_event_handler;
*/

private _display = findDisplay 46;
if !(isNull _display) then
{
	{
		private _files = getArray(_x >> "files");
		private _name = configName _x;
		if !(_files isEqualTo []) then
		{
			private _cmd = "";
			{
				_cmd = _cmd + preprocessFile _x;
			} forEach _files;
			private _id = _display displayAddEventHandler [_name,_cmd];
		} else {
			private _file = preprocessFile format["eventhandlers\display\eh_%1.sqf",_name];
			private _id = _display displayAddEventHandler [_name,_file];
		};
	} forEach (configProperties [missionConfigFile >> "gamemode" >> "displayEventHandler"]);
} else {
	"ERROR: vn_mf_fnc_init_display_event_handler was called before display is ready!" call BIS_fnc_log;
};

// init key binds
call para_c_fnc_init_key_down;
call para_c_fnc_init_key_up;
