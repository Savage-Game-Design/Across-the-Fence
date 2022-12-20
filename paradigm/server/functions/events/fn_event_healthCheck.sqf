/*
    File: fn_event_healthCheck.sqf
    Author:
    Date: 2022-12-01
    Last Update: 2022-12-20
    Public: Yes

    Description:
        Checks the event system for consistency and errors.
        Should be run manually or infrequently, as good performance isn't guaranteed.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

// TODO Fix hashing

para_s_event_clientHealthInfo = createHashMap;
private _requestTime = serverTime;

private _allMachineIds = (allPlayers apply {owner _x}) + [2];

[] remoteExec ["para_g_fnc_event_healthCheck", 0];

waitUntil {
    uisleep 1;
    (keys para_s_event_clientHealthInfo - _allMachineIds) isEqualTo []
    || (serverTime - _requestTime) > 15
};

private _statuses = ["GOOD", "WARNING", "ERROR"];

private _fnc_setStatusIfMoreSevere = {
    params ["_result", "_status"];
    private _currentStatus = _result getOrDefault ["status", "GOOD"];
    if (_statuses find _status > _statuses find _currentStatus) then {
        _result set ["status", _status];
    };
};

private _fnc_reportIssue = {
    params ["_result", "_status", "_message"];
    [_result, _status] call _fnc_setStatusIfMoreSevere;
    _result getOrDefault [_status, [], true] pushBack _message;
};

private _forwardingForOriginMachineId = localNamespace getVariable "para_event_forwardingForOriginMachineId";

private _results = createHashMap;

// Check that every event subscribed to by a client has forwarding set up correctly.
{
    private _clientMachineId = _x;
    private _info = _y;

    {
        private _origin = _x;
        private _listenersByEvent = _y;

        private _forwardingForThisOrigin = _forwardingForOriginMachineId getOrDefault [_origin, createHashMap];

        {
            private _eventName = _x;
            private _listenersByTopic = _y;

            {
                private _topicString = _x;
                private _handlers = _y;

                private _eventForwarding = flatten (_forwardingForThisOrigin getOrDefault [[_eventName, _topicString], []]);

                if (_origin isEqualTo _clientMachineId) then {
                    continue
                };

                if !(_clientMachineId in _eventForwarding) then {
                    [
                        _results,
                        'ERROR',
                        format [
                            "No event forwarding to client %1, from %2, for event %3 with stringified topic %4",
                            _clientMachineId, _origin, _eventName, _topicString
                        ]
                    ] call _fnc_reportIssue;
                };
            } forEach _listenersByTopic;
        } forEach _listenersByEvent;
    } forEach (_info get "listenersByEventOrigin");
} forEach para_s_event_clientHealthInfo;


// Check that every machine is forwarding events that the server requires, and no more.
{
    private _origin = _x;
    private _eventMap = _y;

    private _originForwarding = para_s_event_clientHealthInfo getOrDefault [_origin, createHashMap] get ["eventsToForward", createHashMap];

    {
        private _hashableEvent = _x;
        private _destinations = _y;

        private _isEventWantedByClients = !(flatten _destinations isEqualTo []);

        if (_originForwarding getOrDefault [_hashableEvent, false]) then {
            // If no clients wants the event any more, make sure no clients are forwarding it.
            if (!_isEventWantedByClients) then {
                [
                    _results,
                    'WARNING',
                    format ['Client %1 is forwarding event %2 unnecessarily', _origin, _hashableEvent]
                ] call _fnc_reportIssue;
            };
        } else {
            if (_isEventWantedByClients) then {
                [
                    _results,
                    'ERROR',
                    format ['Client %1 is not forwarding event %2, wanted by %3', _origin, _hashableEvent, flatten _destinations]
                ] call _fnc_reportIssue;
            };
        };
    } forEach _eventMap;
} forEach _forwardingForOriginMachineId;

// TODO - Check for handler existence

_results
