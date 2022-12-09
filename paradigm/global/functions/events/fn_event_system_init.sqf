/*
    File: fn_event_system_init.sqf
    Author:
    Date: 2022-11-20
    Last Update: 2022-12-09
    Public: Yes

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

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

localNamespace setVariable ["para_event_eventsToForward", createHashMap];

// Temporary area for handlers to be saved, before being attached to an event locally.
localNamespace setVariable ["para_event_handlerCache", createHashMap];
// Nested hashmap, machine id -> handlerId -> handler.
// Stored per-machine-id, so we can easily drop when a player disconnects.
localNamespace setVariable ["para_event_handlersByOrigin", createHashMap];
// Listeners, stored by machine id for fast handling when we receive a networked event.
localNamespace setVariable ["para_event_listenersByEventOrigin", createHashMap];
// Paths we've registered a single handler at, for fast unsubscribing.
localNamespace setVariable ["para_event_handlerRegistrations", createHashMap];

if (isServer) then {
    // Maps machine id to an array storing the machine id. (E.g 46 -> [46])
    // This means we can use machine id by reference, and easily remove the entry when the client disconnects.
    localNamespace setVariable ["para_event_machineIdReferences", createHashMap];

    // Contains forwarding entries for specific clients.
    // Indexed by client id, then event hash - gives an array of client references.
    localNamespace setVariable ["para_event_forwardingForOriginMachineId", createHashMap];

    addMissionEventHandler ["PlayerConnected", para_s_fnc_event_onPlayerConnected];
    addMissionEventHandler ["PlayerDisconnected", para_s_fnc_event_onPlayerDisconnected];

    // Need to initialise any already connected players
    {
        _x params ["_playerID", "_ownerId", "_playerUID", "_profileName", "_displayName", "_steamName", "_clientState", "_isHC", "_adminState", "_networkInfo", "_unit"];
        [_playerId, _playerUID, _profileName, false, _ownerId] call para_s_fnc_event_onPlayerConnected;
    } forEach (allUsers apply {getUserInfo _x});
};

