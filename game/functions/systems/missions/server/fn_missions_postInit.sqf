/*
    File: fn_missions_postInit.sqf
    Author: Savage Game Design
    Date: 2023-02-25
    Last Update: 2024-08-22
    Public: No

    Description:
        Server Post init for mission system.
 */

if (!isServer) exitWith {};

// This is assumed to be static at startup.
vgm_missions_zones_targetBoxes = [] call vgm_s_fnc_loc_getTargetBoxIds;
// This is a temporary fix, that disables several un-populated target boxes.
// It's a naive check, that essentially ensures every site type has somewhere to spawn in the zone.
vgm_missions_zones_targetBoxes = vgm_missions_zones_targetBoxes select {
    count ([_x] call vgm_s_fnc_loc_getTargetBoxLocations) >= count ([] call vgm_s_fnc_sites_getAllSiteTypes)
};

publicVariable "vgm_missions_zones_targetBoxes";

