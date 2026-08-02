/*
    File: fn_amblife_postInit.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server post-init for the ambient life system.
        Subscribes to mission lifecycle events and vehicle cleanup handler.
 */

if (!isServer) exitWith {};

// Phronk's civilians, furniture, and wildlife are initialized from init.sqf
// (c\PF\init.sqf, s\PF\init.sqf, s\civ\init.sqf)

// Bicycle hill-assist loop — gentle forward nudge when bikes stall on inclines
[] spawn {
    private _stallMPS = vgm_s_amblife_bikeStallKPH / 3.6;
    private _naturalMPS = vgm_s_amblife_bikeNaturalMPS;
    private _rampRate = vgm_s_amblife_bikeAssistRampRate;
    while {true} do {
        private _kept = [];
        {
            if (alive _x && {!isNull driver _x}) then {
                private _spd = speed _x / 3.6; // current speed in m/s
                if (_spd < _stallMPS && _spd >= 0) then {
                    // Gradual ramp: add a small forward push each tick, capped at natural speed
                    private _newSpd = (_spd + _rampRate) min _naturalMPS;
                    _x setVelocityModelSpace [0, _newSpd, 0];
                };
                _kept pushBack _x;
            };
        } forEach vgm_s_amblife_activeBikes;
        vgm_s_amblife_activeBikes = _kept;
        sleep 1;
    };
};

// Spawn ambient life when a mission starts
["vgm_mission_started", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_amblife_spawnForMission;
}] call para_g_fnc_event_subscribeServer;

// Clean up ambient life when a mission ends
["vgm_mission_ended", {
    (_this#0) params ["_missionId"];
    _missionId call vgm_s_fnc_amblife_cleanupForMission;
}] call para_g_fnc_event_subscribeServer;

// Clean up vehicles attached to virtual squads when they are deleted
["vgm_virtsquad_deleted", {
    (_this#0) params ["_squad"];

    // Single vehicle (civilian cars, boats, bicycle couriers)
    private _vehicle = _squad getOrDefault ["amblife_vehicle", objNull];
    if (!isNull _vehicle) then {
        {_vehicle deleteVehicleCrew _x} forEach crew _vehicle;
        deleteVehicle _vehicle;
    };

    // Multi-vehicle convoys (truck convoys, bicycle convoys)
    private _vehicles = _squad getOrDefault ["amblife_vehicles", []];
    {
        if (!isNull _x) then {
            {_x deleteVehicleCrew _x} forEach crew _x;
            deleteVehicle _x;
        };
    } forEach _vehicles;
}] call para_g_fnc_event_subscribeServer;
