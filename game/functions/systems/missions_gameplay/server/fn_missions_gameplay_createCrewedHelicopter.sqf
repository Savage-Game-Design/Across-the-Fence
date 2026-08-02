/*
    File: fn_missions_gameplay_createCrewedHelicopter.sqf
    Author: Savage Game Design
    Date: 2023-11-24
    Last Update: 2023-11-26
    Public: Yes

    Description:
        Creates helicopter with default AI crew. Makes it invulnerable and disables unnecesary features.

    Parameter(s):
        _class - Class of the helicopter to create [STRING]

    Returns:
        Helicopter [OBJECT]

    Example(s):
        ["vn_b_air_uh1d_02_07"] call vgm_s_fnc_missions_gameplay_createCrewedHelicopter
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
{
    _x allowDamage false;
    _x disableAI "AUTOCOMBAT";
} forEach units _group;

driver _helicopter setCombatBehaviour "CARELESS";
_helicopter setEffectiveCommander driver _helicopter;

// prevent players from taking the seats from AI
[_helicopter, true] remoteExec ["lockDriver", _helicopter];
[_helicopter, [COPILOT_TURRET, true]] remoteExec ["lockTurret", _helicopter];

// Lights off — covert ops
_helicopter setPilotLight false;
_helicopter setCollisionLight false;
{_x disableAI "LIGHTS"} forEach units _group;

// --- Door Gunner Seat Reclaim ---
// Record AI door gunners so they reclaim their turret when a player vacates it
private _gunnerData = [];
{
    _x params ["_unit", "_role", "_cargoIdx", "_turretPath", "_isPersonTurret"];
    if (_turretPath isNotEqualTo [-1] && {_turretPath isNotEqualTo [0]} && {!isNull _unit} && {!isPlayer _unit}) then {
        _gunnerData pushBack [_unit, _turretPath];
    };
} forEach fullCrew _helicopter;

if (count _gunnerData > 0) then {
    _helicopter setVariable ["vgm_doorGunnerData", _gunnerData, true];

    // GetOut fires when any unit leaves the vehicle
    _helicopter addEventHandler ["GetOut", {
        params ["_vehicle", "_role", "_unit"];
        if (!isPlayer _unit) exitWith {};
        [_vehicle] spawn {
            params ["_vehicle"];
            sleep 2;
            private _gunnerData = _vehicle getVariable ["vgm_doorGunnerData", []];
            {
                _x params ["_ai", "_turretPath"];
                if (alive _ai && {_vehicle unitTurret _ai isNotEqualTo _turretPath}) then {
                    _ai moveInTurret [_vehicle, _turretPath];
                };
            } forEach _gunnerData;
        };
    }];
};

_helicopter // return
