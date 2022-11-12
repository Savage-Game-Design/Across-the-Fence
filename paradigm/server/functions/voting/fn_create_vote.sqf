/*
	File: fn_create_vote.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Creates a new vote on all clients.
	
	Parameter(s):
		_title - Title of the vote [String]
		_content - Body of the vote. Will be text parsed after [String]
		_options - String array of option - value pairs [String[]]
		_timeout - Duration of the vote [Number]
		_callback - Function called when the vote ends [Code/Array]
	
	Returns:
		Nothing
	
	Example(s):
		["Testing Vote", "This is a test Vote", [["1", value], ["2", value]], 10, [[1,2,3], {//Code}]] call para_s_fnc_create_vote
*/

params ["_title", "_content", "_options", "_timeout", "_callback"];

if (isNil {localNamespace getVariable "para_s_vote_queue"}) then {	
	localNamespace setVariable ["para_s_vote_queue", []];
	localNamespace setVariable ["para_s_current_vote", []];
};

private _currentVote = localNamespace getVariable "para_s_current_vote";

if !(_currentVote isEqualTo []) exitWith {
	localNamespace getVariable "para_s_vote_queue" pushBack _this;
};

_currentVote = _this;
x = _currentVote;


localNamespace setVariable ["para_s_current_vote", _currentVote];
localNamespace setVariable ["para_s_vote_submitted_players", []];
localNamespace setVariable ["para_s_vote_submitted_answers", []];

[_title, _content, _options apply {_x # 0}, _timeout] remoteExec ["para_c_fnc_show_global_vote", 0];

[_currentVote, _timeout] spawn {
	params ["_vote", "_timeout"];
	uiSleep _timeout;
	if (localNamespace getVariable "para_s_current_vote" isEqualTo _vote) then {
		[] call para_s_fnc_finish_vote;
	};
};