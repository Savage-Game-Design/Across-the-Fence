/*
    File: fnc_event_triggerTargets.sqf
    Author: Savage Game Design
    Date: 2022-11-20
    Last Update: 2023-04-14
    Public: Yes

    Description:
        Triggers the given event on all targets.
        Optional data parameter is sent with the event to those clients.

        NOTE: Uses ONLY remoteExec, so local event handlers won't be called immediately.

    Parameter(s):
        _event - Triggering event. Can either be a string, or [event, topic] array, where event is a string, and topic is anything hashable. [STRING/ARRAY]
        _data - Optional data to send to the clients. This is passed to the callbacks. [ANY]
        _targets - Machines to trigger the event on - accepts anything accepted by remoteExec [ARRAY]

    Returns:
        Nothing

    Example(s):
        ["myCustomEvent", 3, [-clientOwner]] call para_g_fnc_event_triggerTargets;
        [["myCustomEvent", "ducks"], [getPlayerUID player], [2, cursorTarget]] call para_g_fnc_event_triggerTargets;
 */

params ["_event", "_data", "_targets"];

// Standardise event format
if !(_event isEqualType []) then {
    _event = [_event, ""]
};

[clientOwner, _event, _data] remoteExec ["para_g_fnc_event_remoteExec_trigger", _targets];
