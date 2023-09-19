/*
    File: fn_preventGroupAutoDeletion.sqf
    Author: Savage Game Design
    Date: 2023-09-19
    Last Update: 2023-09-19
    Public: Yes

    Description:
        Prevents group deletion when its last member leaves.

    Parameter(s):
        _group - Group to prevent from auto deletion [GROUP]

    Returns:
        Nothing

    Example(s):
        vgm_core_lobbyGroup call vgm_g_fnc_preventGroupAutoDeletion
 */

params [
    ["_group", grpNull, [grpNull]]
];

if (_group getVariable ["vgm_core_preventGroupAutoDeletionEH", -1] > -1) exitWith {};

format ["Disabling auto deletion of group: %1", _group] call vgm_g_fnc_logInfo;

private _eh = _group addEventHandler ["UnitLeft", {
    params ["_group", "_leavingUnit"];

    if (!local _group) exitWith {};
    if (_leavingUnit isKindOf "Logic" || {units _group isEqualTo [_leavingUnit]}) exitWith {};

    format ["Preventing auto deletion of group: %1", _group] call vgm_g_fnc_logDebug;

    private _logic = _group createUnit ["Logic", [0,0,0], [], 0, "CAN_COLLIDE"];
    _logic spawn {deleteVehicle _this};
}];

_group setVariable ["vgm_core_preventGroupAutoDeletionEH", _eh];
