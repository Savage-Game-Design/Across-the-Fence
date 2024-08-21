/*
    File: fn_sites_getSiteTypeRequirements.sqf
    Author: Savage Game Design
    Date: 2024-08-21
    Last Update: 2024-08-21
    Public: No

    Description:
        Returns a list of the required tags for the given site type.

    Parameter(s):
        _siteType - The site type to analyse [HASHMAP]

    Returns:
        List of required tags [ARRAY]

    Example(s):
        private _mySiteType = ["vgm_something"] call vgm_s_fnc_sites_getSiteType;
        private _requirements = [_mySiteType] call vgm_s_fnc_sites_getSiteTypeRequirements;
 */

params ["_siteType"];

private _requirements = _siteType getOrDefault ["locRequirements", []];

if ("size" in _siteType) then {
    _requirements pushBack (_siteType get "size");
};

_requirements
