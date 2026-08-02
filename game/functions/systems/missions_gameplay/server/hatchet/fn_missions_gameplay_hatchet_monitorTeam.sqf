/*
    File: fn_missions_gameplay_hatchet_monitorTeam.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Server-side monitoring script for Hatchet Force recon team.

        Phase 1 (Invulnerability Bubble): No dismounted player within 50m.
        - Recon team is invulnerable but fights PAVN
        - PAVN respawn to maintain the firefight
        - Recon team ammo is periodically refreshed

        Phase 2 (Player Proximity): Any dismounted player within 50m.
        - Recon team becomes vulnerable (full health)
        - PAVN stop respawning
        - Separate "secure" objective when Phase 1 enemies cleared
        - Counterattack wave spawns on secure completion

        Hot LZ two-phase extraction:
        - 5 min after insertion: first bird arrives for AI team (with player hints)
        - After first bird departs: canRequest unlocked, players call their own extraction

    Parameter(s):
        _missionId      - Mission ID [NUMBER]
        _reconTeam      - Array of recon team units [ARRAY]
        _playerGroup    - The player group [GROUP]
        _reconPos       - Position of the recon team [ARRAY]
        _insertionType  - "hot" or "cold" [STRING]
        _spawnedEnemies - Array of spawned PAVN units [ARRAY]
        _reconGrp       - The recon team's group [GROUP]

    Returns:
        Nothing

    Example(s):
        [_missionId, _reconTeam, _playerGroup, _reconPos, _insertionType, _spawnedEnemies, _reconGrp]
            spawn vgm_s_fnc_missions_gameplay_hatchet_monitorTeam;
 */

params ["_missionId", "_reconTeam", "_playerGroup", "_reconPos", "_insertionType", "_spawnedEnemies", "_reconGrp"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {};

private _hatchetNetmap = [_missionId, "hatchet"] call vgm_s_fnc_missions_getSystemNetmap;
private _parentTaskId = format ["vgm_hatchet_%1", _missionId];

private _phase2Triggered = false;
private _reachedTeam = false;
private _secureComplete = false;
private _lastRespawnCheck = serverTime;
private _lastAmmoRefresh = serverTime;
private _missionStartTime = serverTime;
private _insertionTime = serverTime; // will be updated when players land
private _hotLzExtractionStarted = false;
private _hotLzHintShown = createHashMap; // track which time hints have been shown

private _enemyClasses = ["vn_o_men_nva_02", "vn_o_men_nva_03", "vn_o_men_nva_04", "vn_o_men_nva_05", "vn_o_men_nva_06"];

// Player count for scaling respawns
private _playerCount = count (units _playerGroup select {alive _x && isPlayer _x});

while {true} do {
    sleep 5;

    // Check mission still active
    private _missionCheck = [_missionId] call vgm_s_fnc_missions_getById;
    if (isNil "_missionCheck") exitWith {};
    if ((_missionCheck get "public" get "status") != "IN PROGRESS") exitWith {};

    // Count alive recon team (includes incapacitated — they can still be revived)
    private _aliveRecon = _reconTeam select {alive _x};
    private _aliveCount = count _aliveRecon;
    [_hatchetNetmap, "reconTeamAlive", _aliveCount] call para_s_fnc_netmap_set;

    // All recon team dead (truly dead, not just incapacitated) — objective FAILED
    if (_aliveCount == 0) exitWith {
        [format ["%1_reach", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
        [format ["%1_secure", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
        [format ["%1_extract", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
        [_parentTaskId, "FAILED"] call BIS_fnc_taskSetState;

        format ["Hatchet: All recon team KIA for mission %1", _missionId] call vgm_g_fnc_logInfo;
    };

    // Check player proximity — only dismounted players count (helicopter flyover shouldn't trigger)
    private _nearPlayers = units _playerGroup select {alive _x && isPlayer _x && vehicle _x == _x && _x distance _reconPos < 50};

    // === Refresh recon team ammo (Phase 1 only) ===
    if (!_phase2Triggered && {_nearPlayers isEqualTo []}) then {
        if (serverTime - _lastAmmoRefresh > 15) then {
            {
                if (alive _x) then {
                    _x setAmmo [primaryWeapon _x, 30];
                };
            } forEach _reconTeam;
            _lastAmmoRefresh = serverTime;
        };
    };

    // === Respawn PAVN if squads depleted (Phase 1 only — Phase 2 relies on Mission Director at alertness 100) ===
    if (!_phase2Triggered && {serverTime - _lastRespawnCheck > 12}) then {
        private _aliveEnemies = _spawnedEnemies select {alive _x};
        // Scale minimum enemy count with players
        private _minEnemies = 6 + (_playerCount * 2);
        if (count _aliveEnemies < _minEnemies) then {
            private _spawnGrp = createGroup east;
            _spawnGrp deleteGroupWhenEmpty true;
            private _squadSize = 3 + floor (_playerCount / 3);
            _squadSize = _squadSize min 6;

            private _spawnPos = _reconPos getPos [200 + random 100, random 360];
            for "_j" from 1 to _squadSize do {
                private _unit = _spawnGrp createUnit [selectRandom _enemyClasses, _spawnPos, [], 10, "NONE"];
                _spawnedEnemies pushBack _unit;
            };
            _spawnGrp setBehaviourStrong "COMBAT";
            _spawnGrp setCombatMode "RED";
            private _attackWp = _spawnGrp addWaypoint [_reconPos, 0];
            _attackWp setWaypointType "SAD";

            // Update stored enemies
            [_hatchetNetmap, "spawnedEnemies", _spawnedEnemies] call para_s_fnc_netmap_set;
        };
        _lastRespawnCheck = serverTime;
    };

    // === PHASE 2: Player Proximity Triggered ===
    if (!_phase2Triggered && {_nearPlayers isNotEqualTo []}) then {
        _phase2Triggered = true;
        _insertionTime = serverTime;
        [_hatchetNetmap, "phase", "active"] call para_s_fnc_netmap_set;

        format ["Hatchet: Phase 2 triggered — dismounted players within 50m of recon team", _missionId] call vgm_g_fnc_logInfo;

        // Make recon team vulnerable (full health — they've been fighting but holding their own)
        {
            if (alive _x) then {
                _x allowDamage true;
            };
        } forEach _reconTeam;

        // Spike alertness to 100 — maximum enemy response
        private _directorData = _mission getOrDefault ["director", createHashMap];
        if (_directorData isNotEqualTo createHashMap) then {
            private _current = _directorData getOrDefault ["alertness", 0];
            [_directorData, 100 - _current] call vgm_s_fnc_director_addAlertness;
        };
    };

    // === Keep alertness at max during Phase 2 (prevents decay, ensures mortars + reinforcements) ===
    if (_phase2Triggered) then {
        private _directorData = _mission getOrDefault ["director", createHashMap];
        if (_directorData isNotEqualTo createHashMap) then {
            private _current = _directorData getOrDefault ["alertness", 0];
            if (_current < 100) then {
                [_directorData, 100 - _current] call vgm_s_fnc_director_addAlertness;
            } else {
                // Just refresh the event timestamp so decay cooldown resets
                _directorData set ["lastAlertnessEventTime", serverTime];
            };
        };
    };

    // === Check: Player reached recon team (within 50m) ===
    if (!_reachedTeam) then {
        private _veryNear = units _playerGroup select {alive _x && isPlayer _x && vehicle _x == _x && _x distance2D _reconPos < 50};
        if (_veryNear isNotEqualTo []) then {
            _reachedTeam = true;
            [format ["%1_reach", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
            [format ["%1_secure", _parentTaskId], "ASSIGNED"] call BIS_fnc_taskSetState;

            // Hide timer — players reached the team
            [0, false] remoteExec ["vgm_c_fnc_missions_gameplay_bright_light_timerDisplay", _playerGroup];

            ["vgm_voice_hatchet_teamContact", [_missionId, _aliveCount], 2] call para_g_fnc_event_triggerTargets;

            // Transfer recon team to player group so they follow commands
            {
                if (alive _x) then {
                    [_x] joinSilent _playerGroup;
                    _x setVariable ["vgm_hatchet_joinedPlayers", true, true];
                };
            } forEach _reconTeam;

            format ["Hatchet: Players reached recon team (%1 alive) for mission %2", _aliveCount, _missionId] call vgm_g_fnc_logInfo;
        };
    };

    // === Check: Secure objective (Phase 1 enemies cleared near RT) ===
    if (_reachedTeam && !_secureComplete) then {
        private _aliveEnemiesNear = _spawnedEnemies select {alive _x && _x distance2D _reconPos < 300};
        if (count _aliveEnemiesNear <= 2) then {
            _secureComplete = true;
            [format ["%1_secure", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
            [format ["%1_extract", _parentTaskId], "ASSIGNED"] call BIS_fnc_taskSetState;

            // Spawn counterattack wave
            [_reconPos, _playerGroup, _reconTeam, _spawnedEnemies, _hatchetNetmap, _playerCount] spawn vgm_s_fnc_missions_gameplay_hatchet_spawnCounterattack;

            format ["Hatchet: Area secured, counterattack wave spawning for mission %1", _missionId] call vgm_g_fnc_logInfo;
        };
    };

    // === Track extraction: recon NPCs in helicopter ===
    private _extractHeli = _playerGroup getVariable ["vgm_missions_extraction_helicopter", objNull];
    if (!isNull _extractHeli) then {
        private _rescuedCount = {_x in _extractHeli} count _aliveRecon;
        [_hatchetNetmap, "reconTeamRescued", _rescuedCount] call para_s_fnc_netmap_set;

        if (_rescuedCount > 0 && {!_reachedTeam}) then {
            _reachedTeam = true;
            [format ["%1_reach", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
        };

        if (_rescuedCount >= _aliveCount && _aliveCount > 0) then {
            // Mark secure as succeeded if not already (e.g. players loaded RT before clearing area)
            if (!_secureComplete) then {
                _secureComplete = true;
                [format ["%1_secure", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
            };
            [format ["%1_extract", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
            [_parentTaskId, "SUCCEEDED"] call BIS_fnc_taskSetState;

            // Hide timer on success
            [0, false] remoteExec ["vgm_c_fnc_missions_gameplay_bright_light_timerDisplay", _playerGroup];

            format ["Hatchet: All recon team extracted for mission %1", _missionId] call vgm_g_fnc_logInfo;
        };
    };

    // === Hot LZ: Countdown hints ===
    if (_insertionType == "hot" && _phase2Triggered && !_hotLzExtractionStarted) then {
        private _elapsed = serverTime - _insertionTime;
        private _remaining = 300 - _elapsed;

        // Show hints at key intervals (each only once)
        {
            _x params ["_threshold", "_msg"];
            if (_remaining <= _threshold && {!(_threshold in _hotLzHintShown)}) then {
                _hotLzHintShown set [_threshold, true];
                _msg remoteExec ["systemChat", _playerGroup];
            };
        } forEach [
            [300, "COVEY: Defend the LZ — extraction in 5 minutes."],
            [180, "COVEY: Hold position — extraction in 3 minutes."],
            [60,  "COVEY: One minute to extraction — hang in there."]
        ];
    };

    // === Hot LZ: Two-phase extraction ===
    if (_insertionType == "hot" && _phase2Triggered && !_hotLzExtractionStarted) then {
        // 5 minutes after insertion (phase 2 trigger = when players arrive)
        if (serverTime - _insertionTime > 300) then {
            _hotLzExtractionStarted = true;

            private _lzPosASL = _mission get "public" get "startPosASL";
            private _lzPos = ASLToATL _lzPosASL;
            _lzPos set [2, 0];

            [_missionId, _reconTeam, _lzPos, _playerGroup, _hatchetNetmap] spawn {
                params ["_missionId", "_reconTeam", "_lzPos", "_playerGroup", "_hatchetNetmap"];

                // Phase 1: First helicopter for the AI recon team ONLY
                // We do NOT use startExtract here — that would end the mission on liftoff
                ["vgm_voice_hatchet_firstBirdInbound", [_missionId], 2] call para_g_fnc_event_triggerTargets;
                "COVEY: First Slick inbound for RT — do NOT board, that bird is for the recon team." remoteExec ["systemChat", _playerGroup];

                private _originPos = markerPos "vgm_shared_hub";

                private _heli1 = ["vn_b_air_uh1d_02_07"] call vgm_s_fnc_missions_gameplay_createCrewedHelicopter;
                private _spawnPos = _lzPos getPos [3000, _lzPos getDir _originPos];
                _spawnPos set [2, 50];
                _heli1 setPosATL _spawnPos;

                // Use the same LZ the players landed at
                private _safeLzPos = _lzPos findEmptyPosition [0, 100, "vn_b_air_uh1d_02_07"];
                if (_safeLzPos isEqualTo []) then { _safeLzPos = _lzPos; };
                _safeLzPos set [2, 0];

                private _helipad = createVehicle ["Land_vn_helipadempty_f", [0,0,0], [], 0, "NONE"];
                _helipad setPosATL _safeLzPos;
                _heli1 setVariable ["vgm_mission_extraction_helipad", _helipad];

                // Waypoint at approach point (100m out), scriptedLand guides it to helipad
                private _grp = group _heli1;
                private _wpPos = _lzPos getPos [100, _lzPos getDir _originPos];
                private _landWp = _grp addWaypoint [_wpPos, 0];
                _landWp setWaypointStatements ["true", toString {
                    if (!isServer) exitWith {};
                    [vehicle this] call vgm_s_fnc_missions_gameplay_extraction_scriptedLand;
                }];

                // Wait for landing or timeout
                private _timeout = serverTime + 180;
                waitUntil {
                    sleep 3;
                    (_heli1 getVariable ["vgm_missions_extractionLanded", false]) || serverTime > _timeout || !alive _heli1
                };

                // Bird is on the ground — tell players RT is boarding
                "COVEY: RT boarding now — hold the perimeter." remoteExec ["systemChat", _playerGroup];

                // Pull recon team out of player squad and order them into the helicopter
                private _aliveRecon = _reconTeam select {alive _x};
                {
                    [_x] joinSilent _grp;
                    _x setVariable ["vgm_hatchet_joinedPlayers", false, true];
                    _x assignAsCargo _heli1;
                    [_x] orderGetIn true;
                } forEach _aliveRecon;

                // Wait for recon team to board or timeout (30s)
                private _boardTimeout = serverTime + 30;
                waitUntil {
                    sleep 2;
                    ({alive _x && !(_x in _heli1)} count _aliveRecon == 0) || serverTime > _boardTimeout
                };

                // Phase 2: First bird departs
                // Fly away
                _heli1 flyInHeight [100, true];
                private _despawnWp = _grp addWaypoint [markerPos "vgm_mission_heli_despawn", 0];

                // Wait for the helicopter to clear the area before unlocking player extraction
                waitUntil {sleep 3; !alive _heli1 || _heli1 distance2D _lzPos > 500};

                "COVEY: RT is away. Your bird is next — call extraction when ready." remoteExec ["systemChat", _playerGroup];
                _playerGroup setVariable ["vgm_missions_extraction_canRequest", true, true];

                // Clean up first bird after it's had time to fly off
                sleep 45;
                {_heli1 deleteVehicleCrew _x} forEach crew _heli1;
                deleteVehicle _heli1;
                deleteVehicle _helipad;
            };
        };
    };

    // === Survival timer warnings ===
    if (!_phase2Triggered) then {
        private _elapsed = serverTime - _missionStartTime;
        // Warn at 5, 8, and 10 minutes
        if (_elapsed > 300 && {_elapsed < 310}) then {
            ["vgm_voice_hatchet_teamCasualty", [_missionId], 2] call para_g_fnc_event_triggerTargets;
        };
        if (_elapsed > 480 && {_elapsed < 490}) then {
            ["vgm_voice_hatchet_teamCasualty", [_missionId], 2] call para_g_fnc_event_triggerTargets;
        };

        // 10-15 minute hard deadline (12 min): start killing recon NPCs if still in Phase 1
        if (_elapsed > 720) then {
            private _consciousRecon = _aliveRecon select {!(_x call vgm_g_fnc_medical_isUnconscious)};
            if (_consciousRecon isNotEqualTo []) then {
                private _victim = selectRandom _consciousRecon;
                _victim setDamage 1;
                ["vgm_voice_hatchet_teamCasualty", [_missionId], 2] call para_g_fnc_event_triggerTargets;
            };
        };
    };
};
