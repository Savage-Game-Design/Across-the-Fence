/*
    File: fn_locEvents_removeHandlers.sqf
    Author: Savage Game Design
    Date: 2024-02-16
    Last Update: 2024-02-23
    Public: No

    Description:
        Removes a previously registered handler created by vgm_g_fnc_locEvents_onNearbyEvent

    Parameter(s):
        _handlerDetails - Handlers to remove [ARRAY]

    Returns:
        Nothing

    Example(s):
        [group player getVariable "myListenHandler"] call vgm_g_fnc_perception_removeListenHandler
 */

params ["_handlerDetails"];
_handlerDetails params ["_perceptionGroup", "_listenerHash", "_handlerIds"];

private _locEventsData = localNamespace getVariable "vgm_l_locEvents_data";

private _perceptionGroups = _locEventsData get "perceptionGroups";
private _listenerEventTypes = _locEventsData get "listenerEventTypes";

// Perception group may have been wiped
if !(_perceptionGroup in _perceptionGroups) exitWith {};

private _groupDetails = _perceptionGroups get _perceptionGroup;
private _listenersByType = _groupDetails get "listenersByType";

{
    _x params ["_type", "_id"];

    private _typeListeners = _listenersByType get _type;
    private _listenerDetails = _typeListeners get "listenerHandlers" get _listenerHash;

    // If the listener has already been removed, we can skip.
    if (isNil "_listenerDetails") then {
        continue;
    };

    private _handlers = _listenerDetails get "handlers";
    _handlers deleteAt _id;

    // No handlers remain, so stop listening to this type of event.
    if (count _handlers isEqualTo 0) then {
        _typeListeners get "listenerHandlers" deleteAt _listenerHash;
        private _allListeners = _typeListeners get "allListeners";
        _allListeners deleteAt (_allListeners find (_listenerDetails get "listener"));
        _listenerEventTypes get _listenerHash deleteAt [_perceptionGroup, _type];
    };
} forEach _handlerIds;
