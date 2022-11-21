/*
    File: fnc_event_trigger.sqf
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

params ["_event", "_data"];

if !(_event isEqualType []) then {
    _event = [_event, ""];
};

// Send to server if server has asked for this event and topic
// TODO

// Call any local handlers
[clientOwner, _event, _data] call para_g_fnc_event_callRegisteredHandlers;

