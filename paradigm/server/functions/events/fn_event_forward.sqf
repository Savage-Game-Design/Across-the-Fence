/*
    File: fn_event_forward.sqf
    Author: Savage Game Design
    Date: 2022-11-27
    Last Update: 2023-01-29
    Public: No

    Description:
        Forwards the given event to any clients listening to it.
        This works as the server maintains a forwarding table with all listening clients.

    Parameter(s):
        _event - Event to send to any listening clients. Uses both the event name and topic to check for who is listening. [event, topic] [ARRAY]
        _data - Data to send with the event [ANY]

    Returns:
        Nothing

    Example(s):
        [["myCustomEvent", 32], ["ANYTHING"]] remoteExec ["para_s_fnc_event_forward", 2];
 */

params [["_event", nil, [[]], 2], "_data"];

["DEBUG", format ["Forwarding event %1 from %2", _event, remoteExecutedOwner]] call para_g_fnc_log;


private _originMachineId = remoteExecutedOwner;
private _hashableEventWithTopic = [_event] call para_g_fnc_event_convertEventToHashableEvent;
private _generalEvent = [_event # 0, ""];

private _forwardingForOriginMachineId = localNamespace getVariable "para_event_forwardingForOriginMachineId";

private _globalEvents = _forwardingForOriginMachineId getOrDefault [0, createHashMap];
private _machinesListeningToAllOrigins =
    (_globalEvents getOrDefault [_hashableEventWithTopic, []])
    +
    (_globalEvents getOrDefault [_generalEvent, []]);

private _originSpecificEvents =  _forwardingForOriginMachineId getOrDefault [_originMachineId, createHashMap];
private _machinesListeningToThisOrigin =
    (_originSpecificEvents getOrDefault [_hashableEventWithTopic, []])
    +
    (_originSpecificEvents getOrDefault [_generalEvent, []]);

private _allListeningMachines = flatten (_machinesListeningToAllOrigins + _machinesListeningToThisOrigin);

// Stop forwarding if nobody is listening. Can happen when a player disconnects.
// Doing this here is likely cheaper, than looping through all the events the disconnecting client was being forwarded.
// But we can fall back on that approach if we need more performance from the forwarding.
if (_allListeningMachines isEqualTo []) then {
    [[_hashableEventWithTopic]] remoteExec ["para_g_fnc_event_stopForwardingMatchingEventsToServer", _originMachineId];
} else {
    [_originMachineId, _hashableEventWithTopic, _event, _data] remoteExec ["para_g_fnc_event_callRegisteredHandlers", _allListeningMachines - [_originMachineId]];
};

