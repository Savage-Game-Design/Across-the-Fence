/*
    File: fn_carry_attachResponse.sqf
    Author: Savage Game Design
    Date: 2023-12-01
    Last Update: 2023-12-07
    Public: No

    Description:
        Handle server response for attach request.

    Parameter(s):
        _unit - Unit doing the attach [OBJECT]
        _target - Attached target [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_unit, _target] remoteExec ["vgm_c_fnc_carry_attachResponse", _unit];
 */

params ["_unit", "_target"];

_unit setVariable ["vgm_carry_carriedObject", _target];

if (isNull _target) exitWith {
    "Failed to attach" call vgm_g_fnc_logError;
};

format ["Attached: %1 | %2", _unit, _target] call vgm_g_fnc_logInfo;

// prevent unable to move in combat pace
[_unit, "forceWalk", "carry"] call vgm_c_fnc_statusEffect_set;

private _fnc_detach = {
    params ["_unit"];
    private _target = _unit getVariable ["vgm_carry_carriedObject", objNull];

    [_unit, _target] remoteExec ["vgm_s_fnc_carry_detachRequest", 2];
};

private _action = [
    _unit,
    format ["<t color='#ff0000'>%1</t>", localize "STR_VN_REVIVE_ACTION_DROP"],
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdaction_unloaddevice_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdaction_unloaddevice_ca.paa",
    toString {!isNull (_this getVariable ['vgm_carry_carriedObject', objNull])},
    "true",
    {},
    {},
    _fnc_detach,
    {},
    nil,
    1,
    100,
    false
] call BIS_fnc_holdActionAdd;
_unit setVariable ["vgm_carry_actionDrop", _action];
