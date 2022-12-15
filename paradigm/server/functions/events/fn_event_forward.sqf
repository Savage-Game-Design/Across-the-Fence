/*
    File: fn_event_forward.sqf
    Author:
    Date: 2022-11-27
    Last Update: 2022-12-11
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

params ["_event", "_data"];

["DEBUG", format ["Forwarding event %1 from %2", _event, remoteExecutedOwner]] call para_g_fnc_log;

private _originMachineId = remoteExecutedOwner;
private _topicEventHash = hashValue _event;
private _generalEventHash = hashValue [_event # 0, hashValue ""];

private _forwardingForOriginMachineId = localNamespace getVariable "para_event_forwardingForOriginMachineId";

private _globalEvents = _forwardingForOriginMachineId getOrDefault [0, createHashMap];
private _machinesListeningToAllOrigins =
    (_globalEvents getOrDefault [_topicEventHash, []])
    +
    (_globalEvents getOrDefault [_generalEventHash, []]);

private _originSpecificEvents =  _forwardingForOriginMachineId getOrDefault [_originMachineId, createHashMap];
private _machinesListeningToThisOrigin =
    (_originSpecificEvents getOrDefault [_topicEventHash, []])
    +
    (_originSpecificEvents getOrDefault [_generalEventHash, []]);

private _allListeningMachines = flatten (_machinesListeningToAllOrigins + _machinesListeningToThisOrigin);

// Stop forwarding if nobody is listening. Can happen when a player disconnects.
// Doing this here is likely cheaper, than looping through all the events the disconnecting client was being forwarded.
// But we can fall back on that approach if we need more performance from the forwarding.
if (_allListeningMachines isEqualTo []) then {
    [_event] remoteExec ["para_g_fnc_event_stopForwardingMatchingEventsToServer", _originMachineId];
} else {
    [_originMachineId, _event, _data] remoteExec ["para_g_fnc_event_callRegisteredHandlers", _allListeningMachines - [_originMachineId]];
};

