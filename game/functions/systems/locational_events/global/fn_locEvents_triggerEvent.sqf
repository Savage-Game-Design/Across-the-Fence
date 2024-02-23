/*
    File: fn_locEvents_triggerEvent.sqf
    Author: Savage Game Design
    Date: 2024-02-16
    Last Update: 2024-02-23
    Public: Yes

    Description:
        Triggers an event at the given location, with the given notification radius.

        Broadcasts globally, unless _localOnly is passed.

    Parameter(s):
        _perceptionGroup - The perception group ID to send the event to [STRING]
        _pos - Where the event is occurring [ARRAY]
        _radius - How far away can the event be received? [NUMBER]
        _type - Type of event [STRING]
        _details - Event details [ANY]
        _isLocal - Should the event only be sent locally? [BOOLEAN, default false]

    Returns:
        Nothing

    Example(s):
        ["default", [0,0,0], 100, "gunshot", []] call vgm_g_fnc_locEvents_triggerEvent;
 */

params ["_perceptionGroup", "_pos", "_radius", "_type", "_details", ["_isLocal", false]];

private _arguments = _this select [0, 5];

if (_isLocal) then {
    _arguments call vgm_g_fnc_locEvents_callHandlers;
} else {
    _arguments remoteExecCall ["vgm_g_fnc_locEvents_callHandlers", 0];
};
