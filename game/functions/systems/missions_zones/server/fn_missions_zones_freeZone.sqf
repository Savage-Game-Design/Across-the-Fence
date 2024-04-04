/*
    File: fn_missions_selection_freeZone.sqf
    Author: Savage Game Design
    Date: 2024-03-25
    Last Update: 2024-04-04
    Public: Yes

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params [["_targetZone", nil, [""]]];

private _zoneReservationNetmap = ["vgm_missions_zones_zoneReservations"] call para_g_fnc_netmap_get;

if (!(_targetZone in _zoneReservationNetmap)) exitWith {};

format ["Freed zone %1", _targetZone] call vgm_g_fnc_logInfo;

[_zoneReservationNetmap, _targetZone] call para_s_fnc_netmap_deleteAt;
