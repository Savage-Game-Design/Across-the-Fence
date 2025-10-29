/*
    File: fn_missions_zones_postInit.sqf
    Author: Savage Game Design
    Date: 2025-10-29
    Last Update: 2025-10-29
    Public: No

    Description:
        Server postInit for mission zones
 */


if (!isServer) exitWith {};

// This is assumed to be static at startup.
vgm_missions_zones_targetBoxes = [] call vgm_s_fnc_loc_getTargetBoxIds;
// This is a "temporary" fix, that disables several un-populated target boxes.
// It's a naive check, that essentially ensures every site type has somewhere to spawn in the zone.
private _allSiteTypes = keys ([] call vgm_s_fnc_sites_getAllSiteTypes);

vgm_missions_zones_targetBoxes = vgm_missions_zones_targetBoxes select {
    private _box = _x;
    private _locations = [_box] call vgm_s_fnc_loc_getTargetBoxLocations;
    private _hasLzs = _locations getOrDefault ["lz"] isNotEqualTo [];
    private _hasSiteMarkers = _allSiteTypes findIf { _locations getOrDefault [_x, []] isNotEqualTo [] } > -1;
    _hasLzs && _hasSiteMarkers
};

publicVariable "vgm_missions_zones_targetBoxes";
