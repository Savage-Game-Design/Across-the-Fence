/*
    File: fn_rto_clearAvailableAircraft.sqf
    Author: Savage Game Design
    Date: 2026-01-08
    Last Update: 2026-01-08
    Public: No

    Description:
        Removes all of a player's available aircraft

    Parameter(s):
        _playerId - Player whose aircraft should be removed [STRING]

    Returns:
        Nothing

    Example(s):
        [getPlayerId (allPlayers # 0)] call vgm_s_fnc_rto_clearAvailableAircraft;
 */

params ["_playerId"];

private _playerAvailableAircraft = vgm_s_rto_availableAircraft get _playerId;

if (isNil "_playerAvailableAircraft") exitWith {};

[vgm_s_rto_availableAircraft, _playerId] call para_s_fnc_netmap_deleteAt;
[_playerAvailableAircraft] call para_s_fnc_netmap_terminate;
