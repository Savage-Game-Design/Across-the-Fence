/*
    File: sites_getSiteType.sqf
    Author: Savage Game Design
    Date: 2024-05-25
    Last Update: 2024-05-25
    Public: Yes

    Description:
        Retrieves the details for a specific site type.

    Parameter(s):
        _typeId - Type of the site [STRING]

    Returns:
        Site factory, in the same format as vgm_s_fnc_sites_getTemplate [HASHMAP]

    Example(s):
        ["vgm_bunker"] call vgm_s_fnc_sites_getSiteType;
 */

params ["_typeId"];

localNamespace getVariable "vgm_s_sites_siteTypes" get _typeId
