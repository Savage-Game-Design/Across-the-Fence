/*
  Author: Aaron Clark

  Description:
	sets up displayEventHandler event handlers from gamemode displayEventHandler config

  Example Usage:
	call vn_mf_fnc_init_display_event_handler;

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
			private _file = preprocessFile format["eventHandlers\display\eh_%1.sqf",_name];
			private _id = _display displayAddEventHandler [_name,_file];
		};
	} forEach (configProperties [missionConfigFile >> "gamemode" >> "displayEventHandler"]);
} else {
	diag_log "ERROR: vn_mf_fnc_init_display_event_handler was called before display is ready!";
};

// init key binds
call vn_mf_fnc_init_key_down;
call vn_mf_fnc_init_key_up;
