/*
    File: fn_harass_calculate_challenge_rating.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Calculates the challenge rating of a player - this determines the magnitude of the response from the enemy.
    
    Parameter(s):
        _player
    
    Returns:
        Extra Challenge [NUMBER]
    
    Example(s):
        [allPlayers # 0] call para_s_fnc_harass_calculate_challenge_rating
*/

params ["_player"];

//Remove any timed-out events.
private _increaseEvents = _player getVariable ["harassDifficultyEvents", []] select {_x # 2 > serverTime};

private _challengeTotal = para_s_harassBaseChallengeRating;
private _frequencyTotal = 1;

{
	_challengeTotal = _challengeTotal + (_x # 0);
    _frequencyTotal = _frequencyTotal * (_x # 1);
} forEach _increaseEvents;

_challengeTotal = _challengeTotal min para_s_harassMaxChallengeRating;
_frequencyTotal = _frequencyTotal max 0;

_player setVariable ["harassDifficultyEvents", _increaseEvents];

[_challengeTotal, _frequencyTotal]