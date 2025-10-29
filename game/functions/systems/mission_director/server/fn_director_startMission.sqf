/*
    File: fn_director_startMission.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2025-10-26
    Public: Yes

    Description:
        Starts the mission director running on a new mission.

        Generally, this should be called when a mission is started, as the players are deploying.

        Handles:
            - Mission asset creation
            - Overall mission flow
            - AI quantities and behaviour
            - Ending the mission

    Parameter(s):
        _mission - Mission to monitor [HashMap]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_director_startMission
 */

params ["_mission"];

private _directorData = _mission getOrDefault ["director", createHashMap, true];

// Overall "alertness" level of enemy forces. Changes scale of the enemy response.
_directorData set ["alertness", 0];
// Used to smooth out alertness
_directorData set ["alertnessPeriodEnd", 0];
_directorData set ["alertnessAddedThisPeriod", 0];
// Virtual squads assigned to this mission
_directorData set ["virtualSquads", createHashMap];
// Spawned groups for each virtual squad. Helps with JIP and event handling.
_directorData set ["virtualSquadGroups", createHashMap];
// Tracks when the last tracker squad was sent at the players
_directorData set ["lastTrackerSent", -9999];

// REINFORCEMENTS SYSTEM
// Reinforcement type chances
_directorData set ["reinforcementTypeChances", createHashMapFromArray [
    ["OPFOR", 1],
    ["ZOMBIES", 5]
]];
// Chance that a reinforcement check spawns reinforcements
_directorData set ["reinforcementChance", 0.75];
// How often the check runs after the start of an engagement - scales with alertness
_directorData set ["reinforcementCheckFrequencyRangeSecs", [45, 10]];
// Delay before more reinforcements can be sent - scales with alertness
_directorData set ["minTimeBetweenReinforcementsRangeSecs", [180, 120]];
// When reinforcements were last sent for each player
_directorData set ["lastReinforcementSentPerPlayer", createHashMap];

// REINFORCEMENT REQUESTS
// Number of requests in an area required to trigger a reinforcement wave
_directorData set ["reinforcementRequestsRequired", 1];
// Size of the catchment area for reinforcement requests.
// This is currently used for checking players to attack too. If this is made smaller, that code will need updating!
_directorData set ["reinforcementRequestsArea", 100];
// How long before requests expire and are deleted.
_directorData set ["reinforcementRequestsExpirySecs", 60];

// ZOMBIE SETTINGS
_directorData set ["spawnAmbientZombies", vgm_s_director_spawnAmbientZombies];
_directorData set ["zombieSiteTypeChances", +vgm_s_director_zombieSiteTypeChances];

[_directorData] call vgm_s_fnc_director_setupEngagements;
[_directorData] call vgm_s_fnc_director_setupReinforcementRequests;

[] remoteExec ["vgm_c_fnc_director_startClientsideMonitoring", values (_mission get "machineIds")];

[_mission] call vgm_s_fnc_director_spawnInitialPatrols;

private _missionId = _mission get "public" get "id";
private _jobId = format ["missionDirector%1", _missionId];
[_jobId, { _this call vgm_s_fnc_director_processMission }, [_mission], 10] call para_g_fnc_scheduler_add_job;

_directorData set ["schedulerJob", _jobId];

private _locEventHandler = [
    // Event group for players on a mission is the mission id
    _missionId,
    // Listen globally - no location restriction, the event group already filters it to this mission.
    "",
    ["player_gunshots_aggregate", "player_explosion", "player_flare"],
    [_missionId, _directorData],
    {
        params ["_pos", "_type", "_listener", "_details", "_args"];
        // Filter out listener, as it's irrelevant
        [_pos, _type, _details, _args] call vgm_s_fnc_director_onPlayerNoiseEvent
    }
] call vgm_g_fnc_locEvents_onNearbyEvent;

private _zombieLocEventHandler = [
    // Event group for players on a mission is the mission id
    _missionId,
    // Listen globally - no location restriction, the event group already filters it to this mission.
    "",
    ["zombie_alert"],
    [_mission],
    {
        params ["_pos", "_type", "_listener", "_details", "_args"];
        _args params ["_mission"];
        [_mission, _pos] call vgm_s_fnc_director_handleReinforcementRequest;
        [_mission get "director", vgm_s_director_zombieAlertAlertness] call vgm_s_fnc_director_addAlertness;
    }
] call vgm_g_fnc_locEvents_onNearbyEvent;

_directorData set ["locEventHandlers", [_locEventHandler, _zombieLocEventHandler]];
