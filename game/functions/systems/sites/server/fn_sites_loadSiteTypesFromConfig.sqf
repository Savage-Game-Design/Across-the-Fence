/*
    File: fn_sites_loadSiteTypesFromConfig.sqf
    Author:
    Date: 2024-06-28
    Last Update: 2024-08-23
    Public: No

    Description:
        Loads site types from config ready to be used.

    Parameter(s):
        None

    Returns:
        None

    Example(s):
        [] call vgm_s_fnc_sites_loadSiteTypesFromConfig;
 */

["Loading site types from config"] call vgm_g_fnc_logInfo;

// Populate any site types defined in config.
private _rootConfigs = [
    missionConfigFile >> "vgm_site_types",
    configFile >> "vgm_site_types"
];

{
    private _siteTypeConfigs = "getNumber (_x >> 'disabled') == 0" configClasses _x;

    {
        private _generator = getText (_x >> "generatorFunction");
        private _siteGeneratorFunc = [] call compile _generator;
        private _site = [] call _siteGeneratorFunc;
        if !(_site isEqualType createHashMap) then {
            continue;
        };

        _site set ["locationClass", getText (_x >> "locationClass")];

        [configName _x, _site] call vgm_s_fnc_sites_addSiteType;
    } forEach _siteTypeConfigs;
} forEach _rootConfigs;


["%1 site types loaded", count (localNamespace getVariable "vgm_s_sites_siteTypes")] call vgm_g_fnc_logInfo;
