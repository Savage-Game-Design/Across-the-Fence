/*
    File: fn_event_healthCheck.sqf
    Author: Savage Game Design
    Date: 2022-12-01
    Last Update: 2023-01-22
    Public: No

    Description:
        Called by the server, to fetch data for the health check

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] remoteExec ["para_g_fnc_event_healthCheck", 0];
 */

[createHashMapFromArray [
    ["eventsToForward", localNamespace getVariable "para_event_eventsToForward"],
    ["handlers", keys (localNamespace getVariable "para_event_handlersByOrigin")],
    ["listenersByEventOrigin", localNamespace getVariable "para_event_listenersByEventOrigin"]
]] remoteExec ["para_s_fnc_event_reportClientHealth", 2];
