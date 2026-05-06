#include "script_component.inc"

/*
    File: fn_skill_investigate_addFiredEh.sqf
    Author: Savage Game Design
    Date: 2024-03-01
    Last Update: 2026-05-06
    Public: No

    Description:
        Add fired EH for noise visualization to the unit.

    Parameter(s):
        _unit - Unit to add event handler to [OBJECT]

    Returns:
        EH ID [NUMBER]

    Example(s):
        [player] call vgm_c_fnc_skill_investigate_addFiredEh
 */

params ["_unit"];

private _ehId = _unit getVariable ["vgm_c_skill_investigate_firedEh", -1];
if (_ehId > -1) exitWith {_ehId};

_ehId = _unit addEventHandler ["Fired", {
    params ["_unit", "", "", "", "", "", "_projectile"];

    if (time < (_unit getVariable ["vgm_c_skill_investigate_nextShotNoiseTime", -1])) exitWith {};
    _unit setVariable ["vgm_c_skill_investigate_nextShotNoiseTime", time + 1];

    [
        _unit,
        2,
        (_unit worldToModelVisual getPosATLVisual _projectile) vectorAdd [0, 0.4, 0],
        ICON_COLOR_RED
    ] call vgm_c_fnc_skill_investigate_queueNoise;
}];

_unit setVariable ["vgm_c_skill_investigate_firedEh", _ehId];

_ehId // return
