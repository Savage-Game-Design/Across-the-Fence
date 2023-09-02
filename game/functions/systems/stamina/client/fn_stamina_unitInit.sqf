#include "script_component.inc"
/*
    File: fn_stamina_unitInit.sqf
    Author: Savage Game Design
    Date: 2023-08-18
    Last Update: 2023-08-27
    Public: No

    Description:
        Switch local unit to VGM stamina system, disables vanilla stamina.

    Parameter(s):
        _unit - Unit to be switched to VGM stamina system [OBJECT]

    Returns:
        Nothing

    Example(s):
        [player] call vgm_c_fnc_stamina_unitInit
 */

params ["_unit"];

format ["Enabling custom stamina for %1", _unit] call vgm_g_fnc_logInfo;

_unit enableStamina false;

#define TICK_TIME 1
private _idx = addMissionEventHandler ["EachFrame", {
    _thisArgs params ["_deltaT", "_unit"];

    _deltaT = _deltaT + diag_deltaTime;

    if (_deltaT < TICK_TIME) exitWith {
        _thisArgs set [0, _deltaT];
    };

    _deltaT = _deltaT mod TICK_TIME;
    _thisArgs set [0, _deltaT];

    if (!alive _unit) exitWith {
        format ["Disabling custom stamina for %1, unit dead", _unit] call vgm_g_fnc_logDebug;
        removeMissionEventHandler ["EachFrame", _unit getVariable ["vgm_stamina_eh", -1]];
    };

    // unit speed in m/s,
    private _speed = (vectorMagnitude velocity _unit);

    // crouched, prone and swimming movement are slower so we need to adjust current speed
    // this will make the stamina costs roughly the same for all stances
    // this also allows us to balance them easily by changing the "max" speeds of the stances
    private _animCoef = animationState _unit call vgm_c_fnc_stamina_getAnimCoef;
    _speed = (_speed * _animCoef) min 6;

    // 100 / 4 = 25s of full speed sprint
    private _drain = linearConversion [0, MAX_SPEED_STD, _speed, -3, 4, true];
    if (_drain > 0) then {
        _drain = _drain * (_unit getVariable ["vgm_c_staminaDrainCoef", 1]);
    };

    private _stamina = _unit getVariable "vgm_stamina";
    _stamina = _stamina - _drain min 100 max 0;

    _unit setVariable ["vgm_stamina", _stamina];

    private _exhausted = _unit getVariable "vgm_stamina_exhausted";
    if (_stamina < 1 && !_exhausted) then {
        _unit setVariable ["vgm_stamina_exhausted", true];
        _unit setVariable ["vgm_stamina_exhaustedUntil", time + 10];
        [_unit, "forceJog", "stamina"] call vgm_c_fnc_statusEffect_set;
    };
    if (_exhausted && {time > _unit getVariable "vgm_stamina_exhaustedUntil"}) then {
        _unit setVariable ["vgm_stamina_exhausted", false];
        [_unit, "forceJog", "stamina"] call vgm_c_fnc_statusEffect_remove;
    };

}, [0, _unit]];

_unit setVariable ["vgm_stamina_eh", _idx];
_unit setVariable ["vgm_stamina_exhausted", false];
_unit setVariable ["vgm_stamina_exhaustedUntil", -1];
_unit setVariable ["vgm_stamina", 100];

if (isNil {_unit getVariable "vgm_stamina_ehRespawn"}) then {
    private _idx = _unit addEventHandler ["Respawn", {
        params ["_unit"];
        _unit call vgm_c_fnc_stamina_unitInit;
    }];
    _unit setVariable ["vgm_stamina_ehRespawn", _idx];
};
