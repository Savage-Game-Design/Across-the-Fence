/*
    File: fn_greh_removeEventHandlerFromAllUnitsInGroup.sqf
    Author: Savage Game Design
    Date: 2024-02-08
    Last Update: 2024-02-09
    Public: Yes

    Description:
        Removes a previously registered event handler from all units in the group.

    Parameter(s):
        _group - Group to add the handler to [GROUP]
        _handlerId - Previously registered event handler id [STRING]

    Returns:
        Event handler ID [STRING]

    Example(s):
        [group player, "suppressed_1"] call vgm_g_fnc_greh_removeEventHandlerFromAllUnitsInGroup;
 */

params ["_group", "_handlerId"];

{
    [_x, _handlerId] call vgm_g_fnc_greh_removeEventHandlerFromUnit;
} forEach units _group;

_group getVariable "vgm_l_greh_handlers" deleteAt _handlerId;
