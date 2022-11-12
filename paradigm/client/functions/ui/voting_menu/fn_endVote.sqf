/*
	File: fn_endVote.sqf
	Author:  Savage Game Design
	Public: No
	
	Description:
		Ends the vote.
	
	Parameter(s): none
	
	Returns: nothing
	
	Example(s): none
*/

[0.3] call para_c_fnc_hideVote;
missionNamespace setVariable ['#para_c_VoteData', nil];
terminate (missionNamespace getVariable ['#para_c_VoteDurationHandler', scriptNull]);
(uiNamespace getVariable ['#para_c_VoteMenu', displayNull]) closeDisplay 1;

uiSleep 0.4;

private _voteQueue = localNamespace getVariable ["para_c_vote_queue", []];

_voteQueue = _voteQueue select {
	_x params ["_startTime", "_vote"];
	private _timeout = _vote select 3;
	private _shouldSuspend = _vote select 5;
	_shouldSuspend || time < _startTime + _timeout
};

localNamespace setVariable ["para_c_vote_queue", _voteQueue];

if !(_voteQueue isEqualTo []) then {
	//Reduce timeout based on when the vote was created.
	_voteQueue deleteAt 0 params ["_queueTime", "_vote"];
	private _timeout = _vote select 3;
	private _shouldSuspend = _vote select 5;
	private _deltatime = time - _queueTime;
	if !(_shouldSuspend) then {
		_vote set [3, _timeout - _deltatime];
	};
	_vote spawn para_c_fnc_createVote;
};
