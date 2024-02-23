/*
    File: fn_locEvents_callHandlers.sqf
    Author: Savage Game Design
    Date: 2024-02-16
    Last Update: 2024-02-16
    Public: No

    Description:
        Calls handlers for a given event

    Parameter(s):
        _perceptionGroup - The perception group ID to send the event to [STRING]
        _pos - Where the event is occurring [ARRAY]
        _radius - How far away can the event be received? [NUMBER]
        _type - Type of event [STRING]
        _details - Event details [ANY]

    Returns:
        Nothing

    Example(s):
        ["default", [0,0,0], 100, "gunshot", []] call vgm_g_fnc_locEvents_triggerEvent;
 */

params ["_perceptionGroup", "_pos", "_radius", "_type", "_details"];

private _perceptionGroups = localNamespace getVariable "vgm_l_locEvents_data" get "perceptionGroups";

if !(_perceptionGroup in _perceptionGroups) exitWith {};

private _typeListeners = _perceptionGroups get _perceptionGroup get "listenersByType" get _type;

if (isNil "_typeListeners") exitWith {};

private _allListeners = _typeListeners get "allListeners";
private _nearbyListeners = _allListeners inAreaArray [_pos, _radius, _radius, 0, false];
private _listenerHandlers = _typeListeners get "listenerHandlers";

// Call any global listeners for the event.
_nearbyListeners pushBack "";

{
    private _listener = _x;
    private _handlers = values (_listenerHandlers get (hashValue _x) get "handlers");
    {
        _x params ["_args", "_code"];
        [_pos, _type, _listener, _details, _args] call _code;
    } forEach _handlers;
} forEach _nearbyListeners;
