#include "script_component.inc"
/*
    File: fn_medical_addAction.sqf
    Author: Savage Game Design
    Date: 2023-11-10
    Last Update: 2026-03-05
    Public: No

    Description:
        Adds the medical scrollwheel action to a player unit, allowing other
        players to open the medical menu on them (heal / revive).

    Parameter(s):
        _player - Player to add the action to [OBJECT]

    Returns:
        Nothing

    Example(s):
        [player] call vgm_c_fnc_medical_addAction
 */

params ["_player"];

if (isNull _player || {!isPlayer _player} || {_player == player}) exitWith {};

private _existingAction = _player getVariable ["vgm_c_medical_scrollAction", -1];
if (_existingAction > -1) exitWith {};

private _actionId = _player addAction [
    localize "STR_VGM_MEDICAL_UI_OPEN_MEDICAL_MENU",
    {
        params ["_target"];
        [_target] call vgm_c_fnc_medical_openMedicalMenu;
    },
    nil,
    1.5,
    true,
    true,
    "",
    "alive _target && {_this distance _target < 5}"
];

_player setVariable ["vgm_c_medical_scrollAction", _actionId];
