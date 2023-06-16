/*
    File: fn_event_registerClient.sqf
    Author: Savage Gmae Design
    Date: 2022-11-27
    Last Update: 2023-04-07
    Public: No

    Description:
        Unregisters a client when they disconnect, cleaning up after them.
        Tells any other clients to clean up and remove any data associated with the disconnected client.

    Parameter(s):
        _clientMachineId - Machine id of the client to unregister (usually after disconnect) [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_disconnectedOwner] call para_s_fnc_event_unregisterClient
 */

params ["_clientMachineId"];

["INFO", format ["Event system - unregistering client %1", _clientMachineId]] call para_g_fnc_log;

// Tell all clients to remove any listeners for that machine specifically.
[_clientMachineId] remoteExec ["para_g_fnc_event_handlePlayerDisconnected", -_clientMachineId];
