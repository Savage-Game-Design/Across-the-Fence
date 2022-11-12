/*
	File: fn_show_global_vote.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Creates a new vote on the client, which passes the result back to the server.
	
	Parameter(s):
		_title - Title of the vote [STRING]
		_content - Content of the vote [STRING]
		_options - Options to present [ARRAY<STRING>]
		_timeout - Timeout on the vote [NUMBER]
	
	Returns:
		None
	
	Example(s):
		["Goldfish", "Test", ["A", "B"], 30] remoteExec ["para_c_fnc_create_vote", 0];
*/

params ["_title", "_content", "_options", "_timeout"];

[_title, _content, _options, _timeout, {["submit_vote", _this] call para_c_fnc_call_on_server}] call para_c_fnc_createVote;