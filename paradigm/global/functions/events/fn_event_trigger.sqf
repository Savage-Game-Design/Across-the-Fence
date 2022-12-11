/*
    File: fnc_event_trigger.sqf
    Author:
    Date: 2022-11-20
    Last Update: 2022-12-10
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

params ["_event", "_data"];

// Standardise event format, and hash topic to make sure it's a string.
if !(_event isEqualType []) then {
    _event = [_event, hashValue ""]
} else {
    _event = [_event # 0, hashValue (_event # 1)]
};

private _generalEvent = [_event # 0, hashValue ""];

private _eventsToforward = localNamespace getVariable "para_event_eventsToForward";

// Forward event to server only if the client has been asked for it
if (_eventsToForward getOrDefault [hashValue _event, false] || _eventsToForward getOrDefault [hashValue _generalEvent, false]) then {
    [_event, _data] remoteExec ["para_s_fnc_event_forward", 2];
};

// Call any local handlers
[clientOwner, _event, _data] call para_g_fnc_event_callRegisteredHandlers;

