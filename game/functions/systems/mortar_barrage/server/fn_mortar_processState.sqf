/*
    File: fn_mortar_processState.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Main state machine for the mortar barrage system. Called every tick by the scheduler.
        Handles state transitions: SPOTTING → ADJUSTING → FFE ↔ HOLD_FIRE

        Movement check: if team centroid drifts >150m from spotter's last known position,
        transitions to HOLD_FIRE. After hold, returns to SPOTTING with full reset.

    Parameter(s):
        _mission - Mission HashMap [HashMap]

    Returns:
        Nothing

    Example(s):
        [_mission] call vgm_s_fnc_mortar_processState;
*/

params ["_mission"];

private _publicMission = _mission get "public";
if (_publicMission get "status" == "FINISHED") exitWith {
    [_mission] call vgm_s_fnc_mortar_stop;
};

private _directorData = _mission get "director";
private _mortarData = _directorData getOrDefault ["mortarData", createHashMap];
if (_mortarData isEqualTo createHashMap) exitWith {};

// Check alive players
private _missionPlayers = [_mission] call vgm_s_fnc_missions_getPlayers;
private _alivePlayers = _missionPlayers select { alive _x };
if (count _alivePlayers == 0) exitWith {
    ["[Mortar] No alive players, stopping barrage"] call vgm_g_fnc_logInfo;
    [_mission] call vgm_s_fnc_mortar_stop;
};

// Compute current team centroid
private _centroid = [_alivePlayers] call vgm_s_fnc_mortar_getTeamCentroid;
private _state = _mortarData get "state";
private _spotterTargetPos = _mortarData get "spotterTargetPos";

// --- Movement detection (applies in SPOTTING, ADJUSTING, FFE) ---
if (_state in ["SPOTTING", "ADJUSTING", "FFE"]) then {
    private _drift = _centroid distance2D _spotterTargetPos;
    if (_drift > vgm_s_mortar_movementThreshold) then {
        // Team has moved — transition to HOLD_FIRE
        private _holdDuration = (vgm_s_mortar_holdFire_minDuration # 0) +
            random ((vgm_s_mortar_holdFire_minDuration # 1) - (vgm_s_mortar_holdFire_minDuration # 0));
        private _stationaryReq = (vgm_s_mortar_holdFire_stationaryTime # 0) +
            random ((vgm_s_mortar_holdFire_stationaryTime # 1) - (vgm_s_mortar_holdFire_stationaryTime # 0));

        _mortarData set ["state", "HOLD_FIRE"];
        _mortarData set ["holdFireStartTime", serverTime];
        _mortarData set ["holdFireMinDuration", _holdDuration];
        _mortarData set ["stationaryRequired", _stationaryReq];
        _mortarData set ["stationarySince", serverTime];
        _mortarData set ["lastCentroid", _centroid];

        [format ["[Mortar] Team moved %1m (threshold %2m) — HOLD_FIRE (min %3s, stationary req %4s)",
            round _drift, vgm_s_mortar_movementThreshold, round _holdDuration, round _stationaryReq
        ]] call vgm_g_fnc_logInfo;

        _state = "HOLD_FIRE";
    };
};

// --- State machine ---
switch (_state) do {

    // ========================
    // SPOTTING: Single rounds, high dispersion, initial delay
    // ========================
    case "SPOTTING": {
        if (serverTime < _mortarData get "nextFireTime") exitWith {};

        // Pick dispersion
        private _dispersion = (vgm_s_mortar_spotting_dispersion # 0) +
            random ((vgm_s_mortar_spotting_dispersion # 1) - (vgm_s_mortar_spotting_dispersion # 0));

        // Fire a single spotting round
        [_centroid, _dispersion] call vgm_s_fnc_mortar_fireRound;

        private _roundsFired = (_mortarData get "roundsFired") + 1;
        _mortarData set ["roundsFired", _roundsFired];

        // Schedule next round
        private _interval = (vgm_s_mortar_spotting_interval # 0) +
            random ((vgm_s_mortar_spotting_interval # 1) - (vgm_s_mortar_spotting_interval # 0));
        _mortarData set ["nextFireTime", serverTime + _interval];

        // Update spotter's known position
        _mortarData set ["spotterTargetPos", _centroid];

        [format ["[Mortar] SPOTTING round %1/%2 (dispersion=%3m, next in %4s)",
            _roundsFired, vgm_s_mortar_spotting_roundCount, round _dispersion, round _interval
        ]] call vgm_g_fnc_logInfo;

        // Check transition to ADJUSTING
        if (_roundsFired >= vgm_s_mortar_spotting_roundCount) then {
            _mortarData set ["state", "ADJUSTING"];
            _mortarData set ["roundsFired", 0];
            _mortarData set ["adjustStep", 0];
            ["[Mortar] Transitioning to ADJUSTING"] call vgm_g_fnc_logInfo;
        };
    };

    // ========================
    // ADJUSTING: Single rounds, tightening dispersion each step
    // ========================
    case "ADJUSTING": {
        if (serverTime < _mortarData get "nextFireTime") exitWith {};

        private _adjustStep = _mortarData get "adjustStep";
        private _steps = vgm_s_mortar_adjusting_dispersionSteps;

        if (_adjustStep >= count _steps) exitWith {
            // All adjusting steps done — transition to FFE
            _mortarData set ["state", "FFE"];
            _mortarData set ["ffeStartTime", serverTime];
            _mortarData set ["roundsFired", 0];
            _mortarData set ["nextFireTime", serverTime];
            ["[Mortar] Transitioning to FFE"] call vgm_g_fnc_logInfo;
        };

        private _dispersion = _steps # _adjustStep;

        // Fire a single adjusting round
        [_centroid, _dispersion] call vgm_s_fnc_mortar_fireRound;

        _mortarData set ["adjustStep", _adjustStep + 1];

        // Schedule next round
        private _interval = (vgm_s_mortar_adjusting_interval # 0) +
            random ((vgm_s_mortar_adjusting_interval # 1) - (vgm_s_mortar_adjusting_interval # 0));
        _mortarData set ["nextFireTime", serverTime + _interval];

        // Update spotter's known position
        _mortarData set ["spotterTargetPos", _centroid];

        [format ["[Mortar] ADJUSTING step %1/%2 (dispersion=%3m, next in %4s)",
            _adjustStep + 1, count _steps, _dispersion, round _interval
        ]] call vgm_g_fnc_logInfo;
    };

    // ========================
    // FFE: Volleys of 2-4 rounds, tight dispersion, max lethality
    // ========================
    case "FFE": {
        // Check max FFE duration
        private _ffeElapsed = serverTime - (_mortarData get "ffeStartTime");
        if (_ffeElapsed >= vgm_s_mortar_ffe_maxDuration) exitWith {
            // Forced hold fire — ammo resupply simulation
            private _holdDuration = (vgm_s_mortar_holdFire_minDuration # 0) +
                random ((vgm_s_mortar_holdFire_minDuration # 1) - (vgm_s_mortar_holdFire_minDuration # 0));
            private _stationaryReq = (vgm_s_mortar_holdFire_stationaryTime # 0) +
                random ((vgm_s_mortar_holdFire_stationaryTime # 1) - (vgm_s_mortar_holdFire_stationaryTime # 0));

            _mortarData set ["state", "HOLD_FIRE"];
            _mortarData set ["holdFireStartTime", serverTime];
            _mortarData set ["holdFireMinDuration", _holdDuration];
            _mortarData set ["stationaryRequired", _stationaryReq];
            _mortarData set ["stationarySince", serverTime];
            _mortarData set ["lastCentroid", _centroid];

            [format ["[Mortar] FFE max duration reached (%1s) — forced HOLD_FIRE", round _ffeElapsed]] call vgm_g_fnc_logInfo;
        };

        if (serverTime < _mortarData get "nextFireTime") exitWith {};

        // Fire volley
        private _volleySize = (vgm_s_mortar_ffe_roundsPerVolley # 0) +
            floor random (1 + (vgm_s_mortar_ffe_roundsPerVolley # 1) - (vgm_s_mortar_ffe_roundsPerVolley # 0));

        for "_i" from 1 to _volleySize do {
            [_centroid, vgm_s_mortar_ffe_dispersion] call vgm_s_fnc_mortar_fireRound;
        };

        _mortarData set ["nextFireTime", serverTime + vgm_s_mortar_ffe_volleyInterval];

        // Update spotter's known position
        _mortarData set ["spotterTargetPos", _centroid];

        [format ["[Mortar] FFE volley of %1 rounds (elapsed=%2s/%3s)",
            _volleySize, round _ffeElapsed, vgm_s_mortar_ffe_maxDuration
        ]] call vgm_g_fnc_logInfo;
    };

    // ========================
    // HOLD_FIRE: Wait for minimum duration + team stationary before re-spotting
    // ========================
    case "HOLD_FIRE": {
        private _holdElapsed = serverTime - (_mortarData get "holdFireStartTime");
        private _holdMinDuration = _mortarData get "holdFireMinDuration";

        // Check if minimum hold duration has passed
        if (_holdElapsed < _holdMinDuration) exitWith {};

        // Check if team is stationary
        private _lastCentroid = _mortarData get "lastCentroid";
        private _movementSinceLastTick = _centroid distance2D _lastCentroid;

        // If team moved more than 10m since last tick, reset stationary timer
        if (_movementSinceLastTick > 10) then {
            _mortarData set ["stationarySince", serverTime];
        };
        _mortarData set ["lastCentroid", _centroid];

        private _stationaryDuration = serverTime - (_mortarData get "stationarySince");
        private _stationaryRequired = _mortarData get "stationaryRequired";

        if (_stationaryDuration < _stationaryRequired) exitWith {};

        // Re-acquired! Transition back to SPOTTING with full reset
        private _initialDelay = (vgm_s_mortar_spotting_initialDelay # 0) +
            random ((vgm_s_mortar_spotting_initialDelay # 1) - (vgm_s_mortar_spotting_initialDelay # 0));

        _mortarData set ["state", "SPOTTING"];
        _mortarData set ["spotterTargetPos", _centroid];
        _mortarData set ["roundsFired", 0];
        _mortarData set ["adjustStep", 0];
        _mortarData set ["nextFireTime", serverTime + _initialDelay];
        _mortarData set ["stateStartTime", serverTime];
        _mortarData set ["ffeStartTime", -1];

        [format ["[Mortar] Re-acquired after HOLD_FIRE — returning to SPOTTING (delay=%1s)",
            round _initialDelay
        ]] call vgm_g_fnc_logInfo;
    };
};
