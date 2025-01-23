/*
    File: fn_missions_zones_preInit.sqf
    Author: Savage Game Design
    Date: 2024-03-20
    Last Update: 2025-01-23
    Public: No

    Description:
        Server preInit for Mission Selection.
 */

if (!isServer) exitWith {};

vgm_missions_zones_lastSeed = -1;

vgm_missions_zones_targetBoxesModifiers = createHashMap;

vgm_missions_zones_spawnedSites = createHashMap;
["vgm_missions_zones_spawnedSitesPublic"] call para_s_fnc_netmap_createNamedNetmap;

["vgm_missions_zones_zoneReservations"] call para_s_fnc_netmap_createNamedNetmap;
