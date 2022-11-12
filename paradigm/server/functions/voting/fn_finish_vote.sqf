/*
    File: fn_finish_vote.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
		Finishes the current vote
    
    Parameter(s):
		None
    
    Returns:
		None
    
    Example(s):
		[] call para_s_fnc_finish_vote
*/

private _vote = localNamespace getVariable "para_s_current_vote";
private _options = _vote select 2;
private _submittedPlayers = localNamespace getVariable "para_s_vote_submitted_players";
private _submittedAnswers = localNamespace getVariable "para_s_vote_submitted_answers";

private _tally = [];

for "_i" from 1 to count _options do {
	_tally pushBack 0;
};

{
	_tally set [_x, (_tally select _x) + 1];
} forEach _submittedAnswers;

private _winningIndexes = [];
private _winningScore = 0;

{
	if (_x > _winningScore) then {
		_winningScore = _x;
		_winningIndexes = [_forEachIndex];
	};
	if (_x == _winningScore) then {
		_winningIndexes pushBack _forEachIndex;
	};
} forEach _tally;

private _winner = selectRandom _winningIndexes;
private _winningValue = _options select _winner select 1;

// Clear current vote
localNamespace setVariable ["para_s_current_vote", []];

// Trigger result callback
private _callback = _vote select 4;

if (_callback isEqualType {}) then {
	_callback = [[], _callback];
};

[_callback select 0, _winningValue] call (_callback select 1);

// Start next vote, if one is queued.
private _voteQueue = localNamespace getVariable ["para_s_vote_queue", []];
if !(_voteQueue isEqualTo []) then {
	// This won't queue, as we cleared the current vote above.
	(_voteQueue deleteAt 0) call para_s_fnc_create_vote;
};