/*
    File: fn_director_setupEngagements.sqf
    Author: Savage Game Design
    Date: 2025-06-19
    Last Update: 2025-06-19
    Public: Yes

    Description:
        Sets up the engagements system on a mission director

        Must be called before any other engagements functions.

    Parameter(s):
        _director - Director to init engagements on [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_director] call vgm_s_fnc_director_setupEngagements;
 */

params ["_director"];

// Tracks engagements players are in
_director set ["playerEngagements", createHashMap];
_director set ["reinforcementChance", 0.5];
_director set ["reinforcementCheckFrequencySecs", 20];
_director set ["lastReinforcementSentPerPlayer", createHashMap];
_director set ["minTimeBetweenReinforcementsSecs", 150];
