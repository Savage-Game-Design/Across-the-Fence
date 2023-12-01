/*
    File: fn_carry_attachLocal.sqf
    Author: Savage Game Design
    Date: 2023-12-01
    Last Update: 2023-12-01
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_unit", "_target"];

if (!isNull (_target getVariable ["vgm_carry_carrier", objNull])) exitWith {
    format ["Target is already attached to something: %1", _target] call vgm_g_fnc_logError;
    [_unit, objNull] remoteExec ["vgm_c_fnc_carry_attachResponse", _unit];
};

format ["Attaching: %1 | %2", _unit, _target] call vgm_g_fnc_logInfo;

_target setVariable ["vgm_carry_carriedBy", _unit, true];

private _id = format ["vgm_carry_attach$%1", netId _unit];
[_id, {
    // exploit implicitly passed handler ID to get the unit via netId
    private _unit = (_id splitString "$" param [1, "-1"]) call BIS_fnc_objectFromNetId;
    _target = _unit getVariable ["vgm_carry_carriedObject", objNull];

    format ["Delayed attach: %1 | %2", _unit, _target] call vgm_g_fnc_logDebug;

    _target attachTo [_unit, [0.2, -0.07, -1.1], "spine3"];
    _target setDir 0;

    _target switchMove "vn_carried_still";

    // inform the caller about successful attach
    [_unit, _target] remoteExec ["vgm_c_fnc_carry_attachResponse", _unit];

}, 9] call BIS_fnc_runLater;
