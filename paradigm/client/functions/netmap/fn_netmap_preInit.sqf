/*
    File: fn_netmap_add.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-30
    Public: No

    Description:
        Initialises the netmap system on the client

    Parameter(s):
        Nothing

    Returns:
        Nothing

    Example(s):
        N/A - Trigger in functions.hpp as a preInit function.
 */

if (isServer) exitWith {};

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
