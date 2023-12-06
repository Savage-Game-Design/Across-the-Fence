/*
    File: fn_carry_attachLocal.sqf
    Author: Savage Game Design
    Date: 2023-12-01
    Last Update: 2023-12-06
    Public: No

    Description:
        Attach target to unit.

    Parameter(s):
        _unit - Carrying unit [OBJECT]
        _target - Carried unit [OBJECT]

    Returns:
        Nothing

    Example(s):
        [player, cursorObject] remoteExec ["vgm_s_fnc_carry_attachRequest", 2];
 */

params ["_unit", "_target"];

if (!isNull (_target getVariable ["vgm_carry_carriedBy", objNull])) exitWith {
    format ["Target is already attached to something: %1", _target] call vgm_g_fnc_logError;
    [_unit, objNull] remoteExec ["vgm_c_fnc_carry_attachResponse", _unit];
};

if (!alive _unit || lifeState _unit == "INCAPACITATED") exitWith {
    format ["Carrier is downed, unable to carry: %1", _target] call vgm_g_fnc_logError;
    [_unit, objNull] remoteExec ["vgm_c_fnc_carry_attachResponse", _unit];
};

format ["Attaching: %1 | %2", _unit, _target] call vgm_g_fnc_logInfo;

_unit setVariable ["vgm_carry_carriedObject", _target, true];
_target setVariable ["vgm_carry_carriedBy", _unit, true];

_target attachTo [_unit, [0.2, -0.07, -1.1], "spine3"];
_target setDir 0;

// carry anim that allows shooting
[_unit, "AcinPercMstpSrasWrflDnon"] remoteExec ["switchMove"];
[_target, "vn_carried_still"] remoteExec ["switchMove"];

// inform the caller about successful attach
[_unit, _target] remoteExec ["vgm_c_fnc_carry_attachResponse", _unit];
