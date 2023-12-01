/*
    File: fn_carry_detachRequest.sqf
    Author: Savage Game Design
    Date: 2023-12-01
    Last Update: 2023-12-01
    Public: No

    Description:
        Detach carried target from unit.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [attachedTo player, player] call vgm_s_fnc_carry_detachRequest
 */

params ["_unit", "_target", ["_instant", false]];

format ["Detaching: %1 | %2", _unit, _target] call vgm_g_fnc_logInfo;

private _id = format ["vgm_carry_detach$%1", netId _unit];
[_id, {
    // exploit implicitly passed handler ID to get the unit via netId
    private _unit = (_id splitString "$" param [1, "-1"]) call BIS_fnc_objectFromNetId;
    _target = _unit getVariable ["vgm_carry_carriedObject", objNull];

    format ["Delayed detach: %1 | %2", _unit, _target] call vgm_g_fnc_logDebug;

    detach _target;

    if (lifeState _unit != "INCAPACITATED") then {
        [_unit, ""] remoteExec ["switchMove"];
    };

    [_target, (["", "UnconsciousReviveDefault"] select (lifeState _target == "INCAPACITATED"))] remoteExec ["switchMove"];

    _unit setVariable ["vgm_carry_carriedObject", nil, true];
    _target setVariable ["vgm_carry_carriedBy", nil, true];

    // inform the caller about detach
    [_unit, _target] remoteExec ["vgm_c_fnc_carry_detachResponse", _unit];
}, [0, 3.25] select _instant] call BIS_fnc_runLater;
