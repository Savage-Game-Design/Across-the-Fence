/*
    File: fn_event_stopForwardingMatchingEvents.sqf
    Author: Savage Game Design
    Date: 2022-12-04
    Last Update: 2023-01-29
    Public: No

    Description:
        Tells the server to stop forwarding certain events from certain clients.

    Parameter(s):
        _originMachineIds - Machine IDs to stop forwarding from, number [ARRAY]
        _event - Event to stop forwarding, as [event name, topic] formatted [ARRAY]

    Returns:
        Nothing

    Example(s):
        // Stops any event forwarding from the server for myCustomEvent with that topic.
        // Any forwarding from other origins will continue.
        [
            [2],
            ["myCustomEvent", cursorObject]
        ] remoteExec ["para_s_fnc_stopForwardingMatchingEvents", 2];
 */

params ["_originMachineIds", "_event"];

["DEBUG", format ["Stopping forwarding event %1 from %2 to %3", _event, _originMachineIds, remoteExecutedOwner]] call para_g_fnc_log;

private _hashableEvent = [_event] call para_g_fnc_event_convertEventToHashableEvent;
private _machineIdReferences = localNamespace getVariable "para_event_machineIdReferences";
private _forwardingForOriginMachineId = localNamespace getVariable "para_event_forwardingForOriginMachineId";
private _listenerMachineIdReference = _machineIdReferences get remoteExecutedOwner;

private _globalForwarding = _forwardingForOriginMachineId getOrDefault [0, createHashMap] getOrDefault [_hashableEvent, []];

private _clientsToStopForwardingEvent = [];

{
    private _originMachineId = _x;
    private _originMachineForwardingForAllEvents = _forwardingForOriginMachineId getOrDefault [_originMachineId, createHashMap];
    private _originMachineForwarding = _originMachineForwardingForAllEvents getOrDefault [_hashableEvent, []];
    private _originMachineIndex = _originMachineForwarding find _listenerMachineIdReference;

    private _totalStartingEventListeners = count _globalForwarding + count _originMachineForwarding;

    if (_originMachineIndex > -1) then {
        _originMachineForwarding deleteAt _originMachineIndex;
    };

    private _totalRemainingEventListeners = count _globalForwarding + count _originMachineForwarding;

    // Stop forwarding events if we've removed a client, and now no clients are listening
    if (_totalRemainingEventListeners isEqualTo 0 && _totalStartingEventListeners > 0) then {
        _clientsToStopForwardingEvent pushBack _originMachineId;
        // Remove the event, so that (keys _originMachineForwardForAllEvents) gives all events that need forwarding.
        _originMachineForwardingForAllEvents deleteAt _hashableEvent;
    };
} forEach _originMachineIds;

if !(_clientsToStopForwardingEvent isEqualTo []) then {
    [[_hashableEvent]] remoteExec ["para_g_fnc_event_stopForwardingMatchingEventsToServer", _clientsToStopForwardingEvent];
};
