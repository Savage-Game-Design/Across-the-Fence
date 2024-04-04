/*
    File: fn_missions_selection_reserveZone.sqf
    Author: Savage Game Design
    Date: 2024-03-25
    Last Update: 2024-04-04
    Public: Yes

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Zone was reserved successfuly [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
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
