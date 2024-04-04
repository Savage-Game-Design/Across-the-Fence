/*
    File: fn_missions_selection_freeZone.sqf
    Author: Savage Game Design
    Date: 2024-03-25
    Last Update: 2024-04-04
    Public: Yes

    Description:
        Removes the specified mission zone reservation.

    Parameter(s):
        _zone - Name of the zone marker [STRING]

    Returns:
        Nothing

    Example(s):
        ["vgm_targetBox_2"] call vgm_s_fnc_missions_zones_freeZone
 */

params [["_zone", nil, [""]]];

private _zoneReservationNetmap = ["vgm_missions_zones_zoneReservations"] call para_g_fnc_netmap_get;

if (!(_zone in _zoneReservationNetmap)) exitWith {};

format ["Freed zone %1", _zone] call vgm_g_fnc_logInfo;

[_zoneReservationNetmap, _zone] call para_s_fnc_netmap_deleteAt;
