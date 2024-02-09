/*
    File: fn_greh_removeEventHandlerFromUnit.sqf
    Author: Savage Game Design
    Date: 2024-02-09
    Last Update: 2024-02-09
    Public: No

    Description:
        Removes a groupwide event handler that was previously added to the unit.

    Parameter(s):
        _unit - Unit to add the handler to [OBJECT]
        _handlerId - Event handler to remove from the unit [STRING]

    Returns:
        Nothing

    Example(s):
        [units _group # 0, "suppressed_1"] call vgm_g_fnc_greh_removeEventHandlerFromUnit;
 */

params ["_unit", "_handlerId"];

private _handlers = _unit getVariable "vgm_l_greh_handlers";

if !(_handlerId in _handlers) exitWith {};

_handlers get _handlerId params ["_event", "_registeredHandler"];
_unit removeEventHandler [_event, _registeredHandler];
_handlers deleteAt _handlerId;
