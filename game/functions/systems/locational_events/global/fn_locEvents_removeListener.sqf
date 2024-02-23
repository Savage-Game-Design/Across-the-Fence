/*
    File: fn_locEvents_removeListener.sqf
    Author: Savage Game Design
    Date: 2024-02-16
    Last Update: 2024-02-23
    Public: Yes

    Description:
        Removes all of a listener's registered event handlers.

    Parameter(s):
        _listener - Listener to remove [ARRAY/OBJECT/GROUP]

    Returns:
        Nothing

    Example(s):
        [player] call vgm_g_fnc_locEvents_removeListener;
 */

params ["_listener"];

private _locEventsData = localNamespace getVariable "vgm_l_locEvents_data";
private _listenerEventTypes = _locEventsData get "listenerEventTypes";
private _perceptionGroups = _locEventsData get "perceptionGroups";

private _listenerHash = hashValue _listener;

if !(_listenerHash in _listenerEventTypes) exitWith {};

private _eventTypes = keys (_listenerEventTypes get _listenerHash);

{
    _x params ["_perceptionGroup", "_type"];

    private _perceptionGroup = _perceptionGroups get _perceptionGroup;
    if (isNil "_perceptionGroup") then { continue };
    private _typeListeners = _perceptionGroup get "listenersByType" get _type;
    if (isNil "_typeListeners") then { continue };

    private _allListeners = _typeListeners get "allListeners";
    _allListeners deleteAt (_allListeners find _listener);
    _typeListeners get "listenerHandlers" deleteAt _listenerHash;
} forEach _eventTypes;

_listenerEventTypes deleteAt _listenerHash;
// Need to remove from listenerEventTypes
