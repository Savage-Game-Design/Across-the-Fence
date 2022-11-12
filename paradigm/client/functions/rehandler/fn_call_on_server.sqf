/*
	File: fn_call_on_server.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Executes an REHandler function on the server in an unscheduled environment.
	
	Parameter(s):
		_method - Method to remote execute. Must be defined in REHandler config [STRING]
		_params - Parameters to pass to that method [ANY]
	
	Returns:
		None
	
	Example(s):
		["recruiter_join_faction", cursorObject] call para_c_fnc_call_on_server;
*/

params ["_method", "_params"];

[player, _method, _params] remoteExecCall ["para_s_fnc_rehandler", 2];