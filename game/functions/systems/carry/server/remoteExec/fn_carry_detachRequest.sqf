/*
    File: fn_carry_detachRequest.sqf
    Author: Savage Game Design
    Date: 2023-12-01
    Last Update: 2025-02-06
    Public: No

    Description:
        Detach carried target from unit.

    Parameter(s):
        _unit - Carrying unit [OBJECT]
        _target - Carried unit [OBJECT]

    Returns:
        Nothing

    Example(s):
        [attachedTo player, player] remoteExec ["vgm_s_fnc_carry_detachRequest", 2]
 */

params ["_unit", "_target"];

format ["Detaching: %1 | %2", _unit, _target] call vgm_g_fnc_logInfo;

[_target, ([
    "AmovPpneMstpSnonWnonDnon",
    "UnconsciousReviveDefault"
] select (_target call vgm_g_fnc_medical_isUnconscious))] remoteExec ["switchMove"];

private _detachPos = _unit modelToWorldWorld (_unit selectionPosition "RightShoulder" vectorAdd [0,0.1,0]);
private _detachDir = getDir _target - 90;
detach _target;
_target setPosWorld _detachPos;
_target setDir _detachDir;

if !(_unit call vgm_g_fnc_medical_isUnconscious) then {
    [_unit, ""] remoteExec ["switchMove"];
};

_unit setVariable ["vgm_carry_carriedObject", nil, true];
_target setVariable ["vgm_carry_carriedBy", nil, true];

// inform the caller about detach
[_unit, _target] remoteExec ["vgm_c_fnc_carry_detachResponse", _unit];
