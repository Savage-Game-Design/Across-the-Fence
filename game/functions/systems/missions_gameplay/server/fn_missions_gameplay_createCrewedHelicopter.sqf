/*
    File: fn_missions_gameplay_createCrewedHelicopter.sqf
    Author: Savage Game Design
    Date: 2023-11-24
    Last Update: 2023-11-24
    Public: Yes

    Description:
        Creates helicopter with default AI crew. Makes it invulnerable and disables unnecesary features.

    Parameter(s):
        _class - Class of the helicopter to create [STRING]

    Returns:
        Helicopter [OBJECT]

    Example(s):
        ["vn_b_air_uh1d_02_06"] call vgm_s_fnc_missions_gameplay_createCrewedHelicopter
 */

#define PILOT_TURRET [-1]
#define COPILOT_TURRET [0]

params ["_class"];

private _helicopter = createVehicle [_class, [0,0,0], [], 0, "FLY"];

private _group = createVehicleCrew _helicopter;
_helicopter setCaptive true;
{_x triggerDynamicSimulation false} forEach units _group;
_group deleteGroupWhenEmpty true;

_helicopter allowDamage false;
{_x allowDamage false} forEach units _group;

// prevent players from taking the seats from AI
[_helicopter, true] remoteExec ["lockDriver", _helicopter];
[_helicopter, [COPILOT_TURRET, true]] remoteExec ["lockTurret", _helicopter];

_helicopter // return
