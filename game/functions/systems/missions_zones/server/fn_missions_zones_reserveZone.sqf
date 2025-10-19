/*
    File: fn_missions_zones_reserveZone.sqf
    Author: Savage Game Design
    Date: 2024-03-25
    Last Update: 2025-10-29
    Public: Yes

    Description:
        Tries to reserve the specified mission zone for player.

    Parameter(s):
        _playerId   - Player that is doing the reservation [STRING]
        _targetZone - Zone name [STRING]

    Returns:
        Zone was reserved successfuly [BOOL]

    Example(s):
        ["2", "vgm_targetBox_2"] call vgm_s_fnc_missions_zones_reserveZone
 */

params [["_playerId", nil, [""]], ["_targetZone", nil, [""]]];

private _zoneReservationNetmap = ["vgm_missions_zones_zoneReservations"] call para_g_fnc_netmap_get;

if (_targetZone in _zoneReservationNetmap) exitWith {
    format ["Unable to reserve zone %1 for %2", _targetZone, _playerId] call vgm_g_fnc_logInfo;
    false
};

format ["Reserved zone %1 for %2", _targetZone, _playerId] call vgm_g_fnc_logInfo;

[_zoneReservationNetmap, _targetZone, _playerId] call para_s_fnc_netmap_set;

true
