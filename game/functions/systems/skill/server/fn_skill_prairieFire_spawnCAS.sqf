/*
    File: fn_skill_prairieFire_spawnCAS.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server-side handler for the Prairie Fire skill. Spawns a CAS aircraft
        near the player's position with loiter time. The player can then call
        airstrikes using the vanilla vn_artillery system via their handheld radio.

        Aircraft pool: AH-1G Cobra variants, UH-1C gunships, OH-6A Cayuse.
        Only rotary-wing CAS used (loiter-capable aircraft).

    Parameter(s):
        _caller - Player who activated the skill [OBJECT]
        _duration - How long the aircraft stays on station in seconds [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_caller, 480] call vgm_s_fnc_skill_prairieFire_spawnCAS
 */

params ["_caller", "_duration"];

if (!isServer) exitWith {};

// CAS aircraft pool - rotary wing only (can loiter on station)
private _casPool = [
    "vn_b_air_ah1g_04",
    "vn_b_air_ah1g_05",
    "vn_b_air_ah1g_06",
    "vn_b_air_uh1c_01_01",
    "vn_b_air_uh1c_02_01",
    "vn_b_air_uh1c_03_01",
    "vn_b_air_oh6a_03"
];

// Select random aircraft from pool
private _aircraftClass = selectRandom _casPool;

// Spawn position: 2000m away from caller at random direction, 200m altitude
private _callerPos = getPosATL _caller;
private _spawnDir = random 360;
private _spawnDist = 2000;
private _spawnPos = _callerPos getPos [_spawnDist, _spawnDir];
_spawnPos set [2, 200];

// Create the aircraft
private _aircraft = createVehicle [_aircraftClass, _spawnPos, [], 0, "FLY"];
_aircraft setDir (_spawnDir + 180); // Face toward player
_aircraft setVelocityModelSpace [0, 60, 0];

// Create crew
private _group = createGroup [side _caller, true];
private _pilot = _group createUnit ["vn_b_men_sf_06", _spawnPos, [], 0, "NONE"];
_pilot moveInDriver _aircraft;

// Add gunner if vehicle supports it
if (count allTurrets _aircraft > 0) then {
    private _gunner = _group createUnit ["vn_b_men_sf_06", _spawnPos, [], 0, "NONE"];
    _gunner moveInTurret [_aircraft, [0]];
};

// Set aircraft behavior - loiter near player
_group setBehaviourStrong "CARELESS";
_group setCombatMode "BLUE";
_group setSpeedMode "NORMAL";

// Create loiter waypoint near caller
private _wp = _group addWaypoint [_callerPos, 300];
_wp setWaypointType "LOITER";
_wp setWaypointLoiterType "CIRCLE";
_wp setWaypointLoiterRadius 500;
_wp setWaypointBehaviour "CARELESS";

// Mark aircraft for player (so vn_artillery can target through it)
_aircraft setVariable ["vgm_s_skill_prairieFire_owner", _caller, true];
_aircraft setVariable ["vgm_s_skill_prairieFire_active", true, true];

// Grant temporary vn_artillery trait to caller if they don't have it
private _hadArtilleryTrait = _caller getUnitTrait "vn_artillery";
if (!_hadArtilleryTrait) then {
    _caller setUnitTrait ["vn_artillery", true];
};

// Radio transmission raises alertness — PAVN intercepts comms
private _missionId = group _caller getVariable ["vgm_g_missionId", -1];
if (_missionId != -1) then {
    [_missionId] call vgm_s_fnc_director_onRadioTransmission;
};

format ["Prairie Fire: %1 spawned for %2, loiter %3s", _aircraftClass, name _caller, _duration] call vgm_g_fnc_logInfo;

// Voice line: CAS aircraft on station (delayed 5s for immersion)
[5, "cas", "cas_inbound", false, _pilot] call vgm_s_fnc_voicelines_playDelayed;

// Shootdown chance: roll for NVA AAA engagement
[_aircraft, _group, _caller, _missionId, _duration, _hadArtilleryTrait] spawn vgm_s_fnc_skill_prairieFire_shootdown;

// Schedule cleanup after duration
[_aircraft, _group, _caller, _duration, _hadArtilleryTrait] spawn {
    params ["_aircraft", "_group", "_caller", "_duration", "_hadTrait"];

    sleep _duration;

    // If aircraft was shot down, the shootdown handler manages cleanup
    if (_aircraft getVariable ["vgm_s_prairieFire_shotDown", false]) exitWith {};

    // Remove artillery trait if player didn't have it before
    if (!_hadTrait && alive _caller) then {
        _caller setUnitTrait ["vn_artillery", false];
    };

    // Send aircraft away
    if (!isNull _aircraft && alive _aircraft) then {
        // Clear waypoints
        while {count waypoints _group > 0} do {
            deleteWaypoint [_group, 0];
        };

        // Fly away
        private _exitDir = random 360;
        private _exitPos = getPosATL _aircraft getPos [5000, _exitDir];
        _exitPos set [2, 300];

        private _wp = _group addWaypoint [_exitPos, 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointSpeed "FULL";

        _aircraft setVariable ["vgm_s_skill_prairieFire_active", false, true];

        // Delete after reaching exit
        sleep 120;
        if (!isNull _aircraft) then {
            {deleteVehicle _x} forEach crew _aircraft;
            deleteVehicle _aircraft;
        };
    };

    format ["Prairie Fire: Aircraft departed"] call vgm_g_fnc_logInfo;
};
