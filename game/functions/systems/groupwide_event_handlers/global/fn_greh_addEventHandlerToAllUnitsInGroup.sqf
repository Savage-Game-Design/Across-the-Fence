/*
    File: fn_greh_addEventHandlerToAllUnitsInGroup.sqf
    Author: Savage Game Design
    Date: 2024-02-08
    Last Update: 2024-02-09
    Public: Yes

    Description:
        Adds an event handler to all units in the group, and any new units that join.

    Parameter(s):
        _group - Group to add the handler to [GROUP]
        _event - Event to listen to [STRING]
        _handlerCode - Handler to call [CODE]

    Returns:
        Event handler ID [STRING]

    Example(s):
        [group player, "Suppressed", {  do stuff  }] call vgm_g_fnc_greh_addEventHandlerToAllUnitsInGroup;
 */

params ["_group", "_event", "_handlerCode"];

private _handlerCounter = _group getVariable ["vgm_l_greh_handlerCounter", -1];

if (_handlerCounter == -1) then {
    _group setVariable ["vgm_l_greh_handlerCounter", 0];
    _group setVariable ["vgm_l_greh_handlers", createHashMap];
    _group setVariable ["vgm_l_greh_unitJoinedHandler", _group addEventHandler ["UnitJoined", {
        params ["_group", "_newUnit"];

        _newUnit setVariable ["vgm_l_greh_handlers", createHashMap];

        {
            [_newUnit, _x, _y] call vgm_g_fnc_greh_addEventHandlerToUnit;
        } forEach (_group getVariable "vgm_l_greh_handlers");
    }]];
    _group setVariable ["vgm_l_greh_unitLeftHandler", _group addEventHandler ["UnitLeft", {
        params ["_group", "_newUnit"];

        {
            [_newUnit, _x] call vgm_g_fnc_greh_removeEventHandlerFromUnit;
        } forEach (_group getVariable "vgm_l_greh_handlers");
    }]];

    {
        _x setVariable ["vgm_l_greh_handlers", createHashMap];
    } forEach units _group;
};

_handlerCounter = _handlerCounter + 1;
_group setVariable ["vgm_l_greh_handlerCounter", _handlerCounter];

private _handlerId = format ["%1_%2", _event, _handlerCounter];

private _handlers = _group getVariable "vgm_l_greh_handlers";
_handlers set [_handlerId, [_event, _handlerCode]];

{
    [_x, _handlerId, _handlers get _handlerId] call vgm_g_fnc_greh_addEventHandlerToUnit;
} forEach units _group;

_handlerId
