/*
    File: fn_medical_addAction.sqf
    Author: Savage Game Design
    Date: 2023-11-10
    Last Update: 2023-11-17
    Public: No

    Description:
        Add medical treatment action to player unit.

    Parameter(s):
        _player - Player to add the action to [OBJECT]

    Returns:
        Action ID [NUMBER]

    Example(s):
        [player] call vgm_c_fnc_medical_addAction
 */

params ["_player"];

private _actionId = _player getVariable "vgm_medical_actionHeal";
if (!isNil "_actionId") then {
    _player removeAction _actionId;
};

private _text = ["str_a3_cfgactions_healsoldierauto0", "str_a3_cfgactions_healsoldierself0"] select (player == _player);
_actionId = _player addAction [localize _text, {
    params ["_target"];
    _target call vgm_c_fnc_medical_openMedicalMenu;
}, nil, 1, false];

_player setVariable ["vgm_medical_actionHeal", _actionId];

_actionId // return
