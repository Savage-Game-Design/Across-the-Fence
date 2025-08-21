/*
    File: fn_carry_attachResponse.sqf
    Author: Savage Game Design
    Date: 2023-12-01
    Last Update: 2025-08-21
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

private _actionDrop = [
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
_unit setVariable ["vgm_carry_actionDrop", _actionDrop];

private _fnc_canLoad = {
    !isNull (_this getVariable ['vgm_carry_carriedObject', objNull]) && {
        getCursorObjectParams params ["_cursorObject"];
        fullCrew [_cursorObject, "", true] findIf {
            _x params ["_crewUnit", "_role"];
            isNull _crewUnit && {_role != "DRIVER"}
        } > -1
    }
};

private _fnc_load = {
    params ["_unit"];
    private _target = _unit getVariable ["vgm_carry_carriedObject", objNull];
    getCursorObjectParams params ["_cursorObject"];

    [_unit, _target, _cursorObject] remoteExec ["vgm_s_fnc_carry_detachRequest", 2];
};

private _actionLoad = [
    _unit,
    format ["<t color='#ff0000'>%1</t>", localize "STR_VN_REVIVE_ACTION_LOAD"],
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdaction_unloaddevice_ca.paa",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdaction_unloaddevice_ca.paa",
    toString _fnc_canLoad,
    "true",
    {},
    {},
    _fnc_load,
    {},
    nil,
    1,
    101,
    false
] call BIS_fnc_holdActionAdd;
_unit setVariable ["vgm_carry_actionLoad", _actionLoad];
