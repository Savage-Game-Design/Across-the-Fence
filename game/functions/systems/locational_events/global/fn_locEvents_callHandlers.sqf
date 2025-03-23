/*
    File: fn_locEvents_callHandlers.sqf
    Author: Savage Game Design
    Date: 2024-02-16
    Last Update: 2024-11-02
    Public: No

    Description:
        Calls handlers for a given event

        Parameters passed to the handler are:
            _pos - Position of the event
            _type - Event type
            _listener - The listening entity (or position),
            _details - Details of the specific event
            _args - Arguments provided when the handler was registered

    Parameter(s):
        _eventGroup - The event group ID to send the event to [STRING]
        _pos - Where the event is occurring [ARRAY]
        _radius - How far away can the event be received? [NUMBER]
        _type - Type of event [STRING]
        _details - Event details [ANY]

    Returns:
        Nothing

    Example(s):
        ["default", [0,0,0], 100, "gunshot", []] call vgm_g_fnc_locEvents_triggerEvent;
 */

params ["_eventGroup", "_pos", "_radius", "_type", "_details"];

private _eventGroups = localNamespace getVariable "vgm_l_locEvents_data" get "eventGroups";

if !(_eventGroup in _eventGroups) exitWith {};

private _typeListeners = _eventGroups get _eventGroup get "listenersByType" get _type;

if (isNil "_typeListeners") exitWith {};

private _allListeners = _typeListeners get "allListeners";
// Can't use inAreaArray as it doesn't support groups.
private _nearbyListenerIndexes = _allListeners inAreaArrayIndexes [_pos, _radius, _radius, 0, false];
private _listenerHandlers = _typeListeners get "listenerHandlers";

// Call any global listeners for the event.
// This approach scales nicer than other approaches when number of listeners is high.
private _allListenersIncludingGlobal = _allListeners +  [""];
_nearbyListenerIndexes pushBack (count _allListenersIncludingGlobal - 1);

{
    private _listener = _allListenersIncludingGlobal select _x;
    private _handlers = values (_listenerHandlers get (hashValue _listener) get "handlers");
    {
        _x params ["_args", "_code"];
        [_pos, _type, _listener, _details, _args] call _code;
    } forEach _handlers;
} forEach _nearbyListenerIndexes;
