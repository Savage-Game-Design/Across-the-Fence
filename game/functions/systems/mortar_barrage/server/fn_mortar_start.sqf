/*
    File: fn_mortar_start.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Starts the mortar barrage system for a mission.
        Initializes state machine data in directorData and registers a scheduler job.
        Guards against double-start by checking for existing mortarData.

    Parameter(s):
        _mission - Mission HashMap [HashMap]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_mortar_start;
*/

params ["_mission"];

private _directorData = _mission get "director";
if (isNil "_directorData") exitWith {
    ["[Mortar] Cannot start — no director data"] call vgm_g_fnc_logWarning;
};

// Guard against double-start
private _existingData = _directorData getOrDefault ["mortarData", createHashMap];
if !(_existingData isEqualTo createHashMap) exitWith {
    ["[Mortar] Already active, ignoring duplicate start"] call vgm_g_fnc_logInfo;
};

private _missionPlayers = [_mission] call vgm_s_fnc_missions_getPlayers;
private _alivePlayers = _missionPlayers select { alive _x };
if (count _alivePlayers == 0) exitWith {
    ["[Mortar] No alive players, aborting start"] call vgm_g_fnc_logInfo;
};

// Compute initial team centroid
private _centroid = [_alivePlayers] call vgm_s_fnc_mortar_getTeamCentroid;

// Roll initial delay
private _initialDelay = (vgm_s_mortar_spotting_initialDelay # 0) +
    random ((vgm_s_mortar_spotting_initialDelay # 1) - (vgm_s_mortar_spotting_initialDelay # 0));

// Initialize state machine data
private _mortarData = createHashMap;
_mortarData set ["state", "SPOTTING"];
_mortarData set ["spotterTargetPos", _centroid];
_mortarData set ["roundsFired", 0];
_mortarData set ["adjustStep", 0];
_mortarData set ["nextFireTime", serverTime + _initialDelay];
_mortarData set ["stateStartTime", serverTime];
_mortarData set ["ffeStartTime", -1];
_mortarData set ["holdFireStartTime", -1];
_mortarData set ["holdFireMinDuration", 0];
_mortarData set ["lastCentroid", _centroid];
_mortarData set ["stationarySince", serverTime];
_mortarData set ["stationaryRequired", 0];

_directorData set ["mortarData", _mortarData];

// Register scheduler job
private _missionId = _mission get "public" get "id";
private _jobId = format ["mortarBarrage%1", _missionId];
[_jobId, { _this call vgm_s_fnc_mortar_processState }, [_mission], vgm_s_mortar_tickRate] call para_g_fnc_scheduler_add_job;
_mortarData set ["schedulerJobId", _jobId];

// Play incoming warning voice line
["combat", "prairie_fire", true, objNull, true] call vgm_s_fnc_voicelines_play;

[format ["[Mortar] Barrage started on mission %1 — SPOTTING state, initial delay=%2s, centroid=[%3,%4]",
    _missionId, round _initialDelay, round (_centroid # 0), round (_centroid # 1)
]] call vgm_g_fnc_logInfo;
