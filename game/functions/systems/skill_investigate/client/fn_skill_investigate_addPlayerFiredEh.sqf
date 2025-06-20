/*
    File: fn_skill_investigate_addPlayerFiredEh.sqf
    Author: Savage Game Design
    Date: 2024-03-01
    Last Update: 2025-06-18
    Public: No

    Description:
        Add fired EH to turn off "Stop, focus" on the player.

    Parameter(s):
        _unit - Unit to add event handler to [OBJECT]

    Returns:
        EH ID [NUMBER]

    Example(s):
        [player] call vgm_c_fnc_skill_investigate_addFiredEh
 */

params ["_unit"];

private _ehId = _unit getVariable ["vgm_c_skill_investigate_playerFiredEh", -1];
if (_ehId > -1) exitWith {_ehId};

_ehId = _unit addEventHandler ["Fired", {
    params ["_unit"];
    if (_unit getVariable ["vgm_c_skill_investigate_canFireWhileInvestigating", false]) exitWith {};
    [false] call vgm_c_fnc_skill_investigate_setFocusMode;
}];

_unit setVariable ["vgm_c_skill_investigate_playerFiredEh", _ehId];

_ehId // return
