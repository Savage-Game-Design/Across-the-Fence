/*
    File: fn_stamina_unitInit.sqf
    Author: Savage Game Design
    Date: 2023-08-18
    Last Update: 2023-08-18
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

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

    systemChat str ["tick", time];

}, [0, _unit]];

_unit setVariable ["vgm_stamina_eh", _idx];
