/*
    File: fn_missions_gameplay_ambient_departHelicopter.sqf
    Author: Savage Game Design
    Date: 2023-11-24
    Last Update: 2023-11-24
    Public: Yes

    Description:
        Spawns helicopter at given position, orders it to fly away and despawn.

    Parameter(s):
        _position - Position above which the helicopter spawns [ARRAY]
        _class    - Class name of the helicopter [STRING]

    Returns:
        Helicopter [OBJECT]

    Example(s):
        [getPos player] call vgm_s_fnc_missions_gameplay_ambient_departHelicopter
 */

params ["_position", ["_class", "vn_b_air_uh1d_02_06"]];

private _inAirPos = +_position;
_inAirPos set [2, 5];

private _helicopter = createVehicle [_class, [0,0,0], [], 0, "FLY"];
_helicopter setPosATL _inAirPos;
_helicopter setDir random 360;

private _group = createVehicleCrew _helicopter;
_helicopter setCaptive true;
{_x triggerDynamicSimulation false} forEach units _group;
_group deleteGroupWhenEmpty true;

_helicopter allowDamage false;
{_x allowDamage false} forEach units _group;

private _flyToPos = markerPos "vgm_mission_heli_despawn";

_helicopter doMove _flyToPos;
// despawn the heli once it reaches the destination and lands
_helicopter spawn {
    scriptName "vgm_ambient_heliDepart";
    private _timeout = time + 300;
    waitUntil {time > _timeout || unitReady _this};
    {_this deleteVehicleCrew _x} forEach units _this;
    deleteVehicle _this;
};

_helicopter // return
