/*
    File: fn_missions_zones_getUnreservedZones.sqf
    Author: Savage Game Design
    Date: 2025-10-29
    Last Update: 2025-10-29
    Public: Yes

    Description:
        Retrieves all target boxes that aren't yet reserved for a mission

    Parameter(s):
        None

    Returns:
        Target box IDs [ARRAY]

    Example(s):
        [] call vgm_g_fnc_missions_zones_getUnreservedZones;
 */

private _reservedZones = ["vgm_missions_zones_zoneReservations"] call para_g_fnc_netmap_get;

vgm_missions_zones_targetBoxes select { !(_x in _reservedZones) }
