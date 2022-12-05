/*
    File: fn_event_forward.sqf
    Author:
    Date: 2022-11-27
    Last Update: 2022-12-04
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
private _eventHash = hashValue _event;

private _forwardingForOriginMachineId = localNamespace getVariable "para_event_forwardingForOriginMachineId";

private _machinesListeningToAllOrigins = _forwardingForOriginMachineId
    getOrDefault [0, createHashMap]
    getOrDefault [_eventHash, []];

private _machinesListeningToThisOrigin = _forwardingForOriginMachineId
    getOrDefault [_originMachineId, createHashMap]
    getOrDefault [_eventHash, []];

private _allListeningMachines = flatten (_machinesListeningToAllOrigins + _machinesListeningToThisOrigin);

if (_allListeningMachines isEqualTo []) then {
    [_event] remoteExec ["para_g_fnc_event_stopForwardingMatchingEventsToServer", _originMachineId];
} else {
    [_originMachineId, _event, _data] remoteExec ["para_g_fnc_event_callRegisteredHandlers", _allListeningMachines];
};

