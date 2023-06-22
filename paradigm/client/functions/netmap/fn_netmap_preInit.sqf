/*
    File: fn_netmap_add.sqf
    Author:
    Date: 2023-06-22
    Last Update: 2023-06-22
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

localNamespace setVariable ["para_netmaps", createHashMap];

[
    "netmaps received",
    {
        params ["_parameters"];
        _parameters params ["_netmaps"];

        localNamespace setVariable ["para_netmaps", _netmaps];
        {
            [_x] call para_c_fnc_netmap_fixReferences;
        } forEach values _netmaps;

        ["netmaps ready", []] spawn para_g_fnc_event_triggerLocal;
        localNamespace setVariable ["vgm_netmaps_ready", true];
    }
] call para_g_fnc_event_subscribeServer;

[clientOwner] remoteExec ["para_s_fnc_netmap_requestAllNetmaps", 2];
