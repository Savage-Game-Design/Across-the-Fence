/*
    File: fn_missions_postInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2024-08-21
    Public: No

    Description:
        Server Post init for mission system.
 */

if (!isServer) exitWith {};

// This is assumed to be static at startup.
vgm_missions_zones_targetBoxes = [] call vgm_s_fnc_loc_getTargetBoxIds;
publicVariable "vgm_missions_zones_targetBoxes";

