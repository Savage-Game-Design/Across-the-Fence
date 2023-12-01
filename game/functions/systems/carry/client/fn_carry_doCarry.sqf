/*
    File: fn_carry_canCarry.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2023-12-01
    Public: No

    Description:
        Make unit carry the target with pickup animations.

    Parameter(s):
        _unit   - Unit trying to carry [OBJECT]
        _target - Carried unit         [OBJECT]

    Returns:
        Can carry [BOOL]

    Example(s):
        [player, cursorObject] call vgm_c_fnc_carry_doCarry
 */

params ["_unit", "_target"];

if (!isNull (_unit getVariable ["vgm_carry_carriedObject", objNull])) exitWith {
    format ["Already carrying an object: %1", _unit] call vgm_g_fnc_logError;
};

format ["Do carry: %1 | %2", _unit, _target] call vgm_g_fnc_logInfo;

_unit setVariable ["vgm_carry_carriedObject", _target, true];

// position the target so anims are somewhat synchronized
_target attachTo [_unit, [0.22,0.7,0]];
_target setDir 180;

[_unit, "AcinPknlMstpSnonWnonDnon_AcinPercMrunSnonWnonDnon"] remoteExec ["switchMove", 0];
[_target, "AinjPfalMstpSnonWrflDnon_carried_Up"] remoteExec ["switchMove", 0];

// request attach from server to prevent race conditions
[_unit, _target] remoteExec ["vgm_s_fnc_carry_attachRequest", 2];
