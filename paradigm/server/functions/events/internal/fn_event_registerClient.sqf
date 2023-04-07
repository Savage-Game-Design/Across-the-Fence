/*
    File: fn_event_registerClient.sqf
    Author: Savage Game Design
    Date: 2022-11-27
    Last Update: 2023-04-07
    Public: No

    Description:
        Registers a client with the event system when they connect.
        Does initial setup, and tells them up to globally forward events.

    Parameter(s):
        _clientMachineId - Machine id of the client to register with the system [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_clientOwner] call para_s_fnc_event_registerClient
 */

params ["_clientMachineId"];

if (isRemoteExecuted && remoteExecutedOwner isNotEqualTo 0) then {
    _clientMachineId = remoteExecutedOwner;
};

["INFO", format ["Event system - registering client %1", _clientMachineId]] call para_g_fnc_log;
