/*
    File: fn_submit_vote.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Submits a vote from a given player.
    
    Parameter(s):
		_index - Position of option in list [NUMBER]
    
    Returns:
		None
    
    Example(s):
		["submit_vote", 3] call para_c_fnc_call_on_server
*/
//TODO - stop people being able to accidentally submit an answer for the wrong vote.
params ["_index"];

private _vote = localNamespace getVariable "para_s_current_vote";
private _options = _vote select 2;
private _submittedPlayers = localNamespace getVariable "para_s_vote_submitted_players";
private _playerId = getPlayerUID _player;

if (_submittedPlayers find _playerId > -1 || _index < 0 || _index >= count _options) exitWith {};

private _submittedAnswers = localNamespace getVariable "para_s_vote_submitted_answers";

_submittedPlayers pushBack _playerId;
_submittedAnswers pushBack _index;
