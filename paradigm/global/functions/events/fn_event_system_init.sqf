/*
    File: fn_event_system_init.sqf
    Author:
    Date: 2022-11-20
    Last Update: 2022-11-24
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

para_event_handlerCount = 0;
// Max integer value that can be represented in Arma.
para_event_max_integer = 16777216;

localNamespace setVariable ["para_event_handlers", createHashMap];
localNamespace setVariable ["para_event_listenersByEventOrigin", createHashMap];
localNamespace setVariable ["para_event_handlerRegistrationPaths", createHashMap];

