/*
    File: sites_addSiteType.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-05-25
    Public: Yes

    Description:
        Adds a new type of site that can be spawned.

    Parameter(s):
        _siteType - Details for the site, as returned by vgm_s_fnc_sites_getTemplate [HashMap]

    Returns:
        Nothing

    Example(s):
        private _mySite = [] call vgm_s_fnc_sites_getTemplate;
        _mySite set ["id", "vgm_bunker"];
        // ...etc...
        [_mySite] call vgm_s_fnc_sites_addSiteType;
 */

params ["_siteType"];

private _siteTypes = localNamespace getVariable "vgm_s_sites_siteTypes";

if (isNil "_siteTypes") then {
    _siteTypes = createHashMap;
    localNamespace setVariable ["vgm_s_sites_siteTypes", _siteTypes];
};

_siteTypes set [_siteType get "id", _siteType];
