/*
    File: fnc_event_subscribe.sqf
    Author:
    Date: 2022-11-20
    Last Update: 2022-12-04
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

// Standardise event format, and hash topic to make sure it's a string.
if !(_event isEqualType []) then {
    _event = [_event, hashValue ""];
} else {
    _event = [_event # 0, hashValue (_event # 1)]
};

_event params ["_eventName", "_topic"];

// Standardise event handler format to [params, code]
if (_handler isEqualType {}) then {
    _handler = [[], _handler];
};

private _handlerId = format ["%1_%2_%3", _eventName, _topic, para_event_handlerCount];
para_event_handlerCount = para_event_handlerCount + 1;

// Log a warning if the event system is about to break, due to something bugging out and adding too many handlers
if (para_event_handlerCount > para_event_max_integer) then {
    ["WARNING", format ["Possible bug: more than %1 event handlers allocated", para_event_max_integer]] call para_g_fnc_log;
};

private _allHandlers = localNamespace getVariable "para_event_handlers";
_allHandlers set [_handlerId, _handler, true];

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
            || !(_x isEqualTo clientOwner)
            || isServer && !(_x isEqualTo 2)
            || _x < 0
        }
};

private _shouldListenLocally = _clients findIf _isTargetingLocalClient > -1;
private _shouldListenRemotely = _clients findIf _isTargetingRemoteClient > -1;

["DEBUG", format ["New subscription to %1 on %2, with topic %3. Local: %4. Remote: %5", _eventName, _clients, _topic, _shouldListenLocally, _shouldListenRemotely]] call para_g_fnc_log;

// Registering locally-relevant events as machine-specific events like this allows us to speed up local event triggering later
if (_shouldListenLocally) then {
    [[clientOwner], _event, _handlerId] call para_g_fnc_event_attachHandler;
};

if (_shouldListenRemotely) then {
    [_clients, _event, _handlerId] remoteExec ["para_s_fnc_event_startForwardingMatchingEvents", 2];
};

_handlerId




