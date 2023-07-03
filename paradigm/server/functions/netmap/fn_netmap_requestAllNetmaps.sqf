/*
    File: fn_netmap_requestAllNetmaps.sqf
    Author: Savage Game Design
    Date: 2023-06-22
    Last Update: 2023-06-26
    Public: No

    Description:
        Sends all of the serverside netmaps to the client requesting them.

        Primarily used to populate the initial netmap list when a client JIPs.

    Parameter(s):
        _sender - Machine ID of the client requesting the netmaps [NUMBER]

    Returns:
        Nothing

    Example(s):
        [clientOwner] remoteExec ["para_s_fnc_netmap_requestAllNetmaps", 2];
 */

params ["_sender"];

if (_sender isNotEqualTo remoteExecutedOwner && remoteExecutedOwner != 0) exitWith {
    ["ERROR", format ["machine %1 claimed to be %2 when requesting netmaps", remoteExecutedOwner, _sender]] call para_g_fnc_log;
};

private _netmaps = localNamespace getVariable ["para_netmaps", createHashMap];

["netmaps received", _netmaps, [_sender]] call para_g_fnc_event_triggerTargets;

