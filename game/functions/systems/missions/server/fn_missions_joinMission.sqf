/*
    File: fn_missions_joinMission.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2023-06-22
    Public: Yes

    Description:
        Assigns a player to the mission with the given id.

    Parameter(s):
        _playerId - DirectPlay id of player to add to the mission [STRING]
        _missionId - Mission for the player to join [NUMBER]

    Returns:
        Whether or not the assignment was successful [BOOLEAN]

    Example(s):
        [32, getPlayerId player] call vgm_s_fnc_missions_joinMission;
 */

params ["_playerId", "_missionId"];

private _missions = localNamespace getVariable "vgm_missions";

if (
    // Mission needs to exist
    !(_missionId in _missions)
) exitWith {
    [format ["Unable to join player %1 to invalid mission %2", _playerId, _missionId]] call vgm_g_fnc_logWarning;
    false
};

private _mission = _missions get _missionId;

private _joinSuccessful = [_playerId, _mission] call vgm_s_fnc_missions_attachPlayerToMission;

if (!_joinSuccessful) exitWith {
    [format ["Unable to join player %1 to mission %2", _playerId, _missionId]] call vgm_g_fnc_logWarning;
    false
};

true
