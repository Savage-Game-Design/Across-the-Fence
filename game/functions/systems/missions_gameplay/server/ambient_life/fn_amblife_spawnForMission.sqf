/*
    File: fn_amblife_spawnForMission.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Orchestrator: spawns all ambient life for a given mission.
        Computes spatial data, applies performance scaling, and calls each spawner.

    Parameter(s):
        _missionId - ID of the mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        [0] call vgm_s_fnc_amblife_spawnForMission;
 */

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {
    format ["[AmbLife] Mission does not exist: %1", _missionId] call vgm_g_fnc_logError;
};

private _targetZone = _mission get "public" get "targetZone";

// Get target box bounds: [center, [halfW, halfH], direction]
[_targetZone] call vgm_g_fnc_loc_getTargetBoxBounds params ["_boxCenter", "_boxApothems"];

// --- Performance Scaling ---
private _activeMissions = count (values (missionNamespace getVariable ["vgm_s_missions_allMissions", createHashMap]) select {
    (_x get "public" get "status") == "IN PROGRESS"
});

private _budget = +vgm_s_amblife_budgetFull;

if (_activeMissions >= 3) then {
    // 50% budget
    _budget set ["civRoadVehicles", (_budget get "civRoadVehicles") - 1];
    _budget set ["riverBoats", 0];
} else {
    if (_activeMissions == 2) then {
        // 75% budget
        _budget set ["civRoadVehicles", (_budget get "civRoadVehicles") - 1];
    };
};

// --- Compute Spatial Data ---
private _waterPositions = [_boxCenter, _boxApothems] call vgm_s_fnc_amblife_findWaterPositions;
private _roadData = [_boxCenter, _boxApothems] call vgm_s_fnc_amblife_findRoadPositions;
private _buildingPositions = [_boxCenter, _boxApothems] call vgm_s_fnc_amblife_findBuildingPositions;

// Initialize tracking arrays
vgm_s_amblife_missionAnimals set [_missionId, []];
vgm_s_amblife_missionObjects set [_missionId, []];
vgm_s_amblife_missionActive set [_missionId, true];

// --- Call Spawners ---
// Civilians and wildlife are now handled globally by Phronk's systems (s\civ\, s\PF\)
[_missionId, _roadData, _budget get "opforTrucks", _budget get "civRoadVehicles"] call vgm_s_fnc_amblife_spawnRoadTraffic;
[_missionId, _waterPositions, _budget get "riverBoats"] call vgm_s_fnc_amblife_spawnRiverTraffic;
[_missionId, _budget get "bicycleCouriers"] call vgm_s_fnc_amblife_spawnBicycleCouriers;
[_missionId, _roadData, _budget get "bicycleConvoys"] call vgm_s_fnc_amblife_spawnBicycleConvoys;
[_missionId, _roadData, _budget get "workParties"] call vgm_s_fnc_amblife_spawnWorkParties;
[_missionId, _roadData, _budget get "checkpoints"] call vgm_s_fnc_amblife_spawnCheckpoints;
[_missionId, _roadData, _budget get "wireTaps"] call vgm_s_fnc_amblife_spawnWireTaps;
[_missionId, _roadData] call vgm_s_fnc_bda_spawnForMission;

// Civilian reporting removed — Phronk's system handles civilians globally

// --- Start Respawn Monitor for Road Traffic ---
private _respawnHandle = [_missionId, _budget get "opforTrucks", _budget get "civRoadVehicles", _budget get "bicycleConvoys"] spawn vgm_s_fnc_amblife_respawnMonitor;
vgm_s_amblife_missionRespawnHandles set [_missionId, _respawnHandle];

format ["[AmbLife] Spawned ambient life for mission %1 (budget scale: %2 missions active)", _missionId, _activeMissions] call vgm_g_fnc_logInfo;
