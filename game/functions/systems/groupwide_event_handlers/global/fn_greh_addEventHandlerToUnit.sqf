/*
    File: fn_greh_addEventHandlerToUnit.sqf
    Author: Savage Game Design
    Date: 2024-02-09
    Last Update: 2024-02-09
    Public: No

    Description:
        Adds a groupwide event handler to a specific unit (that's already initialised with group event handlers).

    Parameter(s):
        _unit - Unit to add the handler to [OBJECT]
        _handlerId - ID of the handler [STRING]
        _handler - Array of event and handler code [ARRAY]

    Returns:
        Nothing

    Example(s):
        [units _group # 0, "Suppressed", ["Suppressed_1", { }]] call vgm_g_fnc_greh_addEventHandlerToUnit;
 */

params ["_unit", "_handlerId", "_handler"];
_handler params ["_event", "_handlerCode"];

private _registeredHandler = _unit addEventHandler [_event, _handlerCode];

_unit getVariable "vgm_l_greh_handlers" set [_handlerId, [_event, _registeredHandler]];
