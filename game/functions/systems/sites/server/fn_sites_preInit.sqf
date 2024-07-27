/*
    File: sites_preInit.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-07-27
    Public: No

    Description:
        Preinit for the site spawning system.

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        N/A
 */

if (!isServer) exitWith {};

// Only populate siteTypes if it isn't already populated by a call to vgm_s_fnc_sites_addSiteType
private _siteTypesMap = localNamespace getVariable "vgm_s_sites_siteTypes";
if (isNil "_siteTypesMap") then {
    localNamespace setVariable ["vgm_s_sites_siteTypes", createHashMap];
};

[] call vgm_s_fnc_sites_loadSiteTypesFromConfig;


