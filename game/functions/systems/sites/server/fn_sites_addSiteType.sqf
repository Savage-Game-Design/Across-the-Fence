/*
    File: sites_addSiteType.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-07-27
    Public: Yes

    Description:
        Adds a new type of site that can be spawned.

    Parameter(s):
    	_id - Unique ID for the site type [String]
        _siteType - Details for the site, as returned by vgm_s_fnc_sites_getTemplate [HashMap]

    Returns:
        Nothing

    Example(s):
        private _mySite = [] call vgm_s_fnc_sites_getTemplate;
        _mySite set ["id", "vgm_bunker"];
        // ...etc...
        [_mySite] call vgm_s_fnc_sites_addSiteType;
 */

params ["_id", "_siteType"];

private _siteTypes = localNamespace getVariable "vgm_s_sites_siteTypes";

if (isNil "_siteTypes") then {
    _siteTypes = createHashMap;
    localNamespace setVariable ["vgm_s_sites_siteTypes", _siteTypes];
};

// Clone to make sure we have an internal copy, and prevent any weirdness due to outside modification.
private _siteTypeClone = +_siteType;
_siteTypeClone set ["id", _id];

// Clean up location requirements to all be in the same format.
private _locRequirements = _siteType get "locRequirements" apply {toLower trim _x};
_locRequirements sort true;
_siteTypeClone set ["locRequirements", _locRequirements];

_siteTypes set [_id, _siteTypeClone];
