/*
    File: fn_locEvents_deletePerceptionGroup.sqf
    Author: Savage Game Design
    Date: 2024-02-16
    Last Update: 2024-02-23
    Public: Yes

    Description:
        Deletes an entire perception group

    Parameter(s):
        _perceptionGroup - Group ID to deletet [STRING]

    Returns:
        Nothing

    Example(s):
        ["default"] call vgm_g_fnc_locEvents_deletePerceptionGroup;
 */

params ["_perceptionGroup"];

private _locEventsData = localNamespace getVariable "vgm_l_locEvents_data";
_locEventsData get "perceptionGroups" deleteAt _perceptionGroup;

// This leaves data in "listenerEventTypes", but since that's only used for cleanup, we should avoid removing it here.
// If we remove it, we need to iterate all the listeners, which would have awful performance.
