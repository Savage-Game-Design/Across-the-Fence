/*
    File: fn_event_healthCheck.sqf
    Author:
    Date: 2022-12-01
    Last Update: 2022-12-05
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

[createHashMapFromArray [
    ["eventsToForward", localNamespace getVariable "para_event_eventsToForward"],
    ["handlers", keys (localNamespace getVariable "para_event_handlersByOrigin")],
    ["listenersByEventOrigin", localNamespace getVariable "para_event_listenersByEventOrigin"]
]] remoteExec ["para_s_fnc_event_reportClientHealth", 2];
