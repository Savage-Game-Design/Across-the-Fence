/*
    File: fn_missions_getFullness.sqf
    Author: Savage Game Design
    Date: 2025-10-22
    Last Update: 2025-10-22
    Public: Yes

    Description:
        Gets the number of players on a mission, its max player count, and how full it is as a %.

    Parameter(s):
        _mission - Mission to retrieve info from [HASHMAP]

    Returns:
        [ Player Count, Max Players, Fullness % ]

    Example(s):
        [_mission] call vgm_s_fnc_missions_getFullness
 */

params ["_mission"];

private _playerCount = [_mission get "players"] call para_g_fnc_netmap_count;
private _maxPlayers = _mission get "maxPlayers";
private _fullness = _playerCount / _maxPlayers;

[_playerCount, _maxPlayers, _fullness]
