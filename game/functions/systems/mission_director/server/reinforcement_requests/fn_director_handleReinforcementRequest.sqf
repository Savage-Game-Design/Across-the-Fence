/*
    File: fn_director_handleReinforcementRequest.sqf
    Author: Savage Game Design
    Date: 2025-10-22
    Last Update: 2025-10-22
    Public: No

    Description:
        Handles a request for reinforcements from another system.

    Parameter(s):
        _mission - Mission request is coming from [HASHMAP]
        _pos - Position of the request [ARRAY]


    Returns:
        Nothing

    Example(s):
        [_mission, [0, 0, 0]] call vgm_s_fnc_director_handleReinforcementRequest;
 */

params ["_mission", "_pos"];

private _director = _mission get "director";

private _requestTimes = _director get "reinforcementRequestsTimes";
private _requestPositions = _director get "reinforcementRequestsPositions";

// Clean up old requests when we record a new one.
// Performance shouldn't be especially important here, as requests should be fairly rare.
// Note: Algorithm only works as long as request expiry time is stored chronologically.
private _latestValidEntryIndex = _requestTimes findIf { time < _x };
if (_latestValidEntryIndex < 0) then {
    _requestTimes deleteRange [0, count _requestTimes];
    _requestPositions deleteRange [0, count _requestPositions];
} else {
    _requestTimes deleteRange [0, _latestValidEntryIndex];
    _requestPositions deleteRange [0, _latestValidEntryIndex];
};

_requestTimes pushBack (time + (_director get "reinforcementRequestsExpirySecs"));
_requestPositions pushBack _pos;

private _requestArea = _director get "reinforcementRequestsArea";
private _requestsInArea = _requestPositions inAreaArray [_pos, _requestArea, _requestArea];

// Note: This deliberately counts existing requests that haven't expired - so an extra request can trigger another wave, if the timer is low enough.
if (count _requestsInArea >= _director get "reinforcementRequestsRequired") then {
    private _players = [_mission] call vgm_s_fnc_missions_getPlayers;
    private _nearbyPlayers = _players inAreaArray [_pos, _requestArea, _requestArea];

    if (_nearbyPlayers isNotEqualTo []) then {
        [_mission, _nearbyPlayers, "Reinforcement requests"] call vgm_s_fnc_director_attemptReinforcements;
    };
};
