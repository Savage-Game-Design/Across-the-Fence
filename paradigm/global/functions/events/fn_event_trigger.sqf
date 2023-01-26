/*
    File: fnc_event_trigger.sqf
    Author:
    Date: 2022-11-20
    Last Update: 2022-12-20
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

// Standardise event format
if !(_event isEqualType []) then {
    _event = [_event, ""]
};

private _hashableEvent = [_event] call para_g_fnc_event_convertEventToHashableEvent;
private _generalEvent = [_event # 0, ""];

private _eventsToforward = localNamespace getVariable "para_event_eventsToForward";

// Forward event to server only if the client has been asked for it
if (_eventsToForward getOrDefault [_hashableEvent, false] || _eventsToForward getOrDefault [_generalEvent, false]) then {
    [_event, _data] remoteExec ["para_s_fnc_event_forward", 2];
};

// Call any local handlers
[clientOwner, _hashableEvent, _event, _data] call para_g_fnc_event_callRegisteredHandlers;

