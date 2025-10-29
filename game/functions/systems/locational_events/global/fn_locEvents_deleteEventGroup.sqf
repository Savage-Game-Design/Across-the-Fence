/*
    File: fn_locEvents_deleteEventGroup.sqf
    Author: Savage Game Design
    Date: 2024-02-16
    Last Update: 2025-10-22
    Public: Yes

    Description:
        Deletes an entire event group

    Parameter(s):
        _eventGroup - Group ID to delete [STRING]

    Returns:
        Nothing

    Example(s):
        ["default"] call vgm_g_fnc_locEvents_deleteEventGroup;
 */

params ["_eventGroup"];

private _locEventsData = localNamespace getVariable "vgm_l_locEvents_data";
_locEventsData get "eventGroups" deleteAt _eventGroup;

// This leaves data in "listenerEventTypes", but since that's only used for cleanup, we should avoid removing it here.
// If we remove it, we need to iterate all the listeners, which would have awful performance.
// ListenerEventTypes will be cleaned up for most things anyway, as listeners are (usually) units and get deleted.
// The other systems that use this globally will need to take care of cleanup themselves manually.
