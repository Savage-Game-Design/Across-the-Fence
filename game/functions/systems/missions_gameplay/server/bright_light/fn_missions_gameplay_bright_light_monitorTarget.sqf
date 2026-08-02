/*
    File: fn_missions_gameplay_bright_light_monitorTarget.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-05
    Public: No

    Description:
        Server-side monitoring script for Bright Light rescue target.
        Tracks: target alive, found (player near), carried, in helicopter.
        Downed pilot variants:
          Variant A (pilot_at_crash): NVA assault 30-60s after players approach crash.
          Variant B (pilot_captured): tracks intel gathered, updates tasks to site.
        Timer is removed when any player reaches crash (100m).

    Parameter(s):
        _missionId   - Mission ID [NUMBER]
        _target      - The rescue target NPC [OBJECT]
        _playerGroup - The player group [GROUP]

    Returns:
        Nothing

    Example(s):
        [_missionId, _target, _playerGroup] spawn vgm_s_fnc_missions_gameplay_bright_light_monitorTarget;
 */

params ["_missionId", "_target", "_playerGroup"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {};

private _blNetmap = [_missionId, "bright_light"] call vgm_s_fnc_missions_getSystemNetmap;
private _parentTaskId = format ["vgm_bright_light_%1", _missionId];

// Read variant info
private _pilotVariant = _blNetmap getOrDefault ["pilotVariant", ""];
private _crashPos = _blNetmap getOrDefault ["crashPos", [0,0,0]];
private _sitePos = _blNetmap getOrDefault ["sitePos", [0,0,0]];
// rescueType is always "downed_pilot"

private _found = false;
private _carried = false;

// Variant A state
private _assaultTriggered = false;
private _assaultCountdown = -1;

// Variant B state
private _intelProcessed = false;
private _trailFollowed = false;

// Timer removal state
private _timerRemoved = false;

// Bleed-out timer: target takes damage over time
private _lastBleedTime = serverTime;
private _bleedInterval = 120;

while {true} do {
    sleep 2;

    private _missionCheck = [_missionId] call vgm_s_fnc_missions_getById;
    if (isNil "_missionCheck") exitWith {};
    if ((_missionCheck get "public" get "status") != "IN PROGRESS") exitWith {};

    // Target died
    if (!alive _target) exitWith {
        [_blNetmap, "targetFound", _found] call para_s_fnc_netmap_set;

        // Fail all relevant subtasks
        [format ["%1_locate", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
        if (_pilotVariant == "pilot_captured") then {
            [format ["%1_gatherIntel", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
            [format ["%1_followTrail", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
            [format ["%1_rescue", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
        } else {
            [format ["%1_secure", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
        };
        [format ["%1_extract", _parentTaskId], "FAILED"] call BIS_fnc_taskSetState;
        [_parentTaskId, "FAILED"] call BIS_fnc_taskSetState;

        // Remove timer
        if (!_timerRemoved) then {
            [0, false] remoteExec ["vgm_c_fnc_missions_gameplay_bright_light_timerDisplay", _playerGroup];
            _timerRemoved = true;
        };

        format ["Bright Light: Target KIA for mission %1", _missionId] call vgm_g_fnc_logInfo;
    };

    // Bleed-out: if target is NOT being carried, they take periodic damage
    private _carriedBy = _target getVariable ["vgm_carry_carriedBy", objNull];
    if (isNull _carriedBy && {serverTime - _lastBleedTime > _bleedInterval}) then {
        private _currentDamage = damage _target;
        _target setDamage (_currentDamage + 0.15);
        _lastBleedTime = serverTime;
        format ["Bright Light: Target bleed tick, damage now %1", damage _target] call vgm_g_fnc_logInfo;
    };

    // --- Timer removal: any player within 100m of crash ---
    if (!_timerRemoved && {_crashPos isNotEqualTo [0,0,0]}) then {
        private _nearCrash = units _playerGroup select {alive _x && isPlayer _x && _x distance2D _crashPos < 100};
        if (_nearCrash isNotEqualTo []) then {
            [0, false] remoteExec ["vgm_c_fnc_missions_gameplay_bright_light_timerDisplay", _playerGroup];
            _timerRemoved = true;
            format ["Bright Light: Timer removed — players reached crash for mission %1", _missionId] call vgm_g_fnc_logInfo;
        };
    };

    // --- VARIANT A: Assault trigger ---
    if (_pilotVariant == "pilot_at_crash" && !_assaultTriggered) then {
        private _nearPlayers = units _playerGroup select {alive _x && isPlayer _x && _x distance2D _crashPos < 100};
        if (_nearPlayers isNotEqualTo [] && _assaultCountdown < 0) then {
            _assaultCountdown = serverTime + 30 + random 30;
            format ["Bright Light: Assault countdown started for mission %1", _missionId] call vgm_g_fnc_logInfo;
        };

        if (_assaultCountdown > 0 && serverTime >= _assaultCountdown) then {
            _assaultTriggered = true;
            [_blNetmap, "assaultTriggered", true] call para_s_fnc_netmap_set;

            // Calculate average player position
            private _avgPos = [0,0,0];
            private _alivePlayers = units _playerGroup select {alive _x && isPlayer _x};
            {
                _avgPos = _avgPos vectorAdd (getPosATL _x);
            } forEach _alivePlayers;
            _avgPos = _avgPos vectorMultiply (1 / (count _alivePlayers max 1));

            // Spawn NVA assault from opposite bearing +/- 30 degrees
            private _bearingToPlayers = _crashPos getDir _avgPos;
            private _assaultBearing = (_bearingToPlayers + 180) mod 360;

            private _enemyClasses = ["vn_o_men_nva_02", "vn_o_men_nva_03", "vn_o_men_nva_04", "vn_o_men_nva_05", "vn_o_men_nva_06", "vn_o_men_nva_07"];
            private _squadCount = 2 + floor random 2;
            private _spawnedUnits = _blNetmap getOrDefault ["spawnedUnits", []];

            for "_i" from 1 to _squadCount do {
                private _squadBearing = _assaultBearing + (-30 + random 60);
                private _spawnPos = _crashPos getPos [150 + random 100, _squadBearing];

                private _assaultGrp = createGroup east;
                _assaultGrp deleteGroupWhenEmpty true;

                private _squadSize = 4 + floor random 3;
                for "_j" from 1 to _squadSize do {
                    private _unit = _assaultGrp createUnit [selectRandom _enemyClasses, _spawnPos, [], 10, "NONE"];
                    _spawnedUnits pushBack _unit;
                };

                _assaultGrp setBehaviourStrong "AWARE";
                _assaultGrp setCombatMode "RED";
                private _wp = _assaultGrp addWaypoint [_crashPos, 30];
                _wp setWaypointType "SAD";
            };

            [_blNetmap, "spawnedUnits", _spawnedUnits] call para_s_fnc_netmap_set;
            format ["Bright Light: NVA assault spawned (%1 squads) for mission %2", _squadCount, _missionId] call vgm_g_fnc_logInfo;
        };
    };

    // --- VARIANT B: Intel + blood trail tracking ---
    if (_pilotVariant == "pilot_captured") then {
        // Check if players reached crash (40m) and no living enemies within 40m — succeed locate
        if (!_found) then {
            private _nearCrash = units _playerGroup select {alive _x && isPlayer _x && _x distance2D _crashPos < 40};
            private _nearEnemies = _crashPos nearEntities ["Man", 40] select {alive _x && side group _x == east};
            if (_nearCrash isNotEqualTo [] && {_nearEnemies isEqualTo []}) then {
                _found = true;
                [_blNetmap, "targetFound", true] call para_s_fnc_netmap_set;
                [format ["%1_locate", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
                [format ["%1_gatherIntel", _parentTaskId], "ASSIGNED"] call BIS_fnc_taskSetState;

                ["vgm_voice_bright_light_crashSecure", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;
                format ["Bright Light: Crash site found (Variant B) for mission %1", _missionId] call vgm_g_fnc_logInfo;
            };
        };

        // Check if intel was gathered (netmap flag set by hold action)
        if (!_intelProcessed) then {
            private _intelGathered = _blNetmap getOrDefault ["intelGathered", false];
            if (_intelGathered) then {
                _intelProcessed = true;
                [format ["%1_gatherIntel", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
                [format ["%1_followTrail", _parentTaskId], "ASSIGNED"] call BIS_fnc_taskSetState;

                format ["Bright Light: Intel processed, follow trail assigned for mission %1", _missionId] call vgm_g_fnc_logInfo;
            };
        };

        // Check if players reached the capture site (50m) — complete followTrail, assign rescue
        if (_intelProcessed && !_trailFollowed && {_sitePos isNotEqualTo [0,0,0]}) then {
            private _nearSite = units _playerGroup select {alive _x && isPlayer _x && _x distance2D _sitePos < 50};
            if (_nearSite isNotEqualTo []) then {
                _trailFollowed = true;
                [format ["%1_followTrail", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
                [format ["%1_rescue", _parentTaskId], "ASSIGNED"] call BIS_fnc_taskSetState;
                [format ["%1_rescue", _parentTaskId], _sitePos] call BIS_fnc_taskSetDestination;

                format ["Bright Light: Trail followed, rescue task assigned at site %1 for mission %2", _sitePos, _missionId] call vgm_g_fnc_logInfo;
            };
        };
    };

    // --- Standard "found" check (Variant A / missing_operator) ---
    // Players within 25m of target AND no living enemies within 25m
    if (!_found && _pilotVariant != "pilot_captured") then {
        private _nearPlayers = units _playerGroup select {alive _x && isPlayer _x && _x distance _target < 25};
        private _nearEnemies = (getPosATL _target) nearEntities ["Man", 25] select {alive _x && side group _x == east};
        if (_nearPlayers isNotEqualTo [] && {_nearEnemies isEqualTo []}) then {
            _found = true;
            [_blNetmap, "targetFound", true] call para_s_fnc_netmap_set;
            [format ["%1_locate", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
            [format ["%1_secure", _parentTaskId], "ASSIGNED"] call BIS_fnc_taskSetState;

            ["vgm_voice_bright_light_crashSecure", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;
            format ["Bright Light: Target found for mission %1", _missionId] call vgm_g_fnc_logInfo;
        };
    };

    // --- Target being carried ---
    if (_found && !_carried && {!isNull _carriedBy}) then {
        _carried = true;
        [_blNetmap, "targetRescued", true] call para_s_fnc_netmap_set;

        if (_pilotVariant == "pilot_captured") then {
            [format ["%1_rescue", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
        } else {
            [format ["%1_secure", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
        };
        [format ["%1_extract", _parentTaskId], "ASSIGNED"] call BIS_fnc_taskSetState;

        ["vgm_voice_bright_light_targetPickedUp", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;
        format ["Bright Light: Target picked up by %1 for mission %2", name _carriedBy, _missionId] call vgm_g_fnc_logInfo;
    };

    // --- Target in extraction helicopter ---
    private _extractHeli = _playerGroup getVariable ["vgm_missions_extraction_helicopter", objNull];
    if (!isNull _extractHeli && {_target in _extractHeli}) then {
        [_blNetmap, "targetExtracted", true] call para_s_fnc_netmap_set;
        [format ["%1_extract", _parentTaskId], "SUCCEEDED"] call BIS_fnc_taskSetState;
        [_parentTaskId, "SUCCEEDED"] call BIS_fnc_taskSetState;

        if (!_timerRemoved) then {
            [0, false] remoteExec ["vgm_c_fnc_missions_gameplay_bright_light_timerDisplay", _playerGroup];
            _timerRemoved = true;
        };

        format ["Bright Light: Target extracted for mission %1", _missionId] call vgm_g_fnc_logInfo;
        breakOut "monitorLoop";
    };
};
