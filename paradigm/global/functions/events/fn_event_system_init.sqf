/*
    File: fn_event_system_init.sqf
    Author: Savage Game Design
    Date: 2022-11-20
    Last Update: 2023-04-07
    Public: Yes

    Description:
        Initialises the event system for use.
        If called on a client in a multiplayer environment, the server *must* have the event system started on it first.

    Parameter(s):
        _forceReinitialise - Runs the initialisation again, even if the system is already initialised [BOOLEAN]

    Returns:
        Nothing

    Example(s):
        [] call para_g_fnc_event_system_init
 */

params [["_forceReinitialise", false]];

if (!isNil "para_event_initialised" && !_forceReinitialise) exitWith {};

para_event_initialised = true;

// Incremented for each event handler, allowing IDs that are unique on this client to be easily created
para_event_handlerCount = 0;
// Max integer value that can be represented in Arma.
para_event_max_integer = 16777216;
// Max players the system supports. Used to create some fixed-size arrays.
para_event_max_supported_players = 60;

// Template array we can copy, with room for an entry for each client.
// Very fast to copy, enumerate and modify, making them preferable to hashmaps which are slow to copy and enumerate.
// Also very fast to turn into a flat list using `flatten`
para_event_client_array_template = [];
para_event_client_array_template resize [para_event_max_supported_players, []];

// Nested hashmap, machine id -> handlerId -> handler.
// Stored per-machine-id, so we can easily drop when a player disconnects.
localNamespace setVariable ["para_event_handlersByOrigin", createHashMap];
// Listeners, stored by machine id for fast handling when we receive a networked event.
localNamespace setVariable ["para_event_listenersByEventOrigin", createHashMap];
// Paths we've registered a handler at, for fast unsubscribing. Indexed by handlerId
localNamespace setVariable ["para_event_handlerRegistrations", createHashMap];

if (isServer) then {
    // Maps machine id to an array storing the machine id. (E.g 46 -> [46])
    // This means we can use machine id by reference, and easily remove the entry when the client disconnects.
    localNamespace setVariable ["para_event_machineIdReferences", createHashMap];

    // Contains forwarding entries for specific clients.
    // Indexed by client id, then event hash - gives an array of client references.
    localNamespace setVariable ["para_event_forwardingForOriginMachineId", createHashMap];

    addMissionEventHandler ["PlayerConnected", {
        params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];
        [_owner] call para_s_fnc_event_registerClient;
    }];

    addMissionEventHandler ["PlayerDisconnected", {
        params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];
        [_owner] call para_s_fnc_event_unregisterClient;
    }];
};

// Assumes the server has been set up with the event system already. This should be guaranteed by the mission.
[] remoteExec ["para_s_fnc_event_registerClient", 2];
