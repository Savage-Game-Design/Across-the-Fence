/*
    File: fnc_event_subscribe.sqf
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
        [parameter] call paraX_fnc_component_myFunction
 */

params [["_clients", [clientOwner]], "_event", "_handler"];

// Standardise event format
if !(_event isEqualType []) then {
    _event = [_event, ""];
};

// Standardise event handler format to [params, code]
if (_handler isEqualType {}) then {
    _handler = [[], _handler];
};

private _hashableEvent = [_event] call para_g_fnc_event_convertEventToHashableEvent;

_event params [["_eventName", nil, [""]], "_topic"];
private _topicString = _hashableEvent # 1;

private _handlerId = format ["%1_%2_%3", _eventName, _topicString, para_event_handlerCount];
para_event_handlerCount = para_event_handlerCount + 1;

// Log a warning if the event system is about to break, due to something bugging out and adding too many handlers
if (para_event_handlerCount > para_event_max_integer) then {
    ["WARNING", format ["Possible bug: more than %1 event handlers allocated", para_event_max_integer]] call para_g_fnc_log;
};

// Stages the handler, ready to be attached to an event.
// Allows the server to tell us to attach to the event, with the correct machine ids.
private _handlerCache = localNamespace getVariable "para_event_handlerCache";
_handlerCache set [_handlerId, _handler, true];

private _isTargetingLocalClient = {
       _x isEqualType objNull &&
        {
            local _x
        }
    || _x isEqualType 0 &&
        {
               _x isEqualTo 0
            || _x isEqualTo clientOwner
            || isServer && _x isEqualTo 2
            || _x < 0 && _x != -clientOwner
        }
};

private _isTargetingRemoteClient = {
       _x isEqualType objNull &&
        {
            !local _x
        }
    || _x isEqualType 0 &&
        {
               _x isEqualTo 0
            || (_x isNotEqualTo clientOwner)
            || isServer && (_x isNotEqualTo 2)
            || _x < 0
        }
};

private _shouldListenLocally = _clients findIf _isTargetingLocalClient > -1;
private _shouldListenRemotely = _clients findIf _isTargetingRemoteClient > -1;

["DEBUG", format ["New subscription to %1 on %2, with topic %3 (%4). Local: %5. Remote: %6", _eventName, _clients, _topic, _topicString, _shouldListenLocally, _shouldListenRemotely]] call para_g_fnc_log;

// Registering locally-relevant events as machine-specific events like this allows us to speed up local event triggering later
if (_shouldListenLocally) then {
    // Keep in cache if events need forwarding, so that the server can also add the handler later.
    private _keepHandlerInCache = _shouldListenRemotely;
    [[clientOwner], _hashableEvent, _event, _handlerId, _keepHandlerInCache] call para_g_fnc_event_attachHandler;
};

if (_shouldListenRemotely) then {
    [_clients, _event, _handlerId] remoteExec ["para_s_fnc_event_startForwardingMatchingEvents", 2];
};

_handlerId
