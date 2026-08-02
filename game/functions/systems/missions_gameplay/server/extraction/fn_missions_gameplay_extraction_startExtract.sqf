/*
    File: fn_missions_gameplay_extraction_callExtract.sqf
    Author: Savage Game Design
    Date: 2023-11-24
    Last Update: 2025-11-20
    Public: No

    Description:
        Starts helicopter extraction for the given mission. Auto-completes the mission once all players boarded the heli.

    Parameter(s):
        _missionId - ID of the mission [NUMBER]
        _lzPosition - Position where heli will land [ARRAY]

    Returns:
        Helicopter [OBJECT]

    Example(s):
        [call vgm_c_fnc_missions_getCurrentMission get "id", getPos player] remoteExecCall ["vgm_s_fnc_missions_gameplay_extraction_startExtract", 2]
 */

params [
    "_missionId",
    ["_lzPosition", []],
    ["_useExactLzPosition", false],
    ["_class", "vn_b_air_uh1d_02_07"],
    ["_distance", 3000],
    ["_originPos", markerPos "vgm_shared_hub"]
];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;

if (isNil "_mission") exitWith {
    format ["Unable to extract, no mission with id: %1", _missionId] call vgm_g_fnc_logError;
};

private _playerGroup = _mission get "public" get "group";
if (!(_playerGroup getVariable ["vgm_missions_extraction_canRequest", true])) exitWith {
    format ["Already requested an extraction: %1", _missionId] call vgm_g_fnc_logError;
};
_playerGroup setVariable ["vgm_missions_extraction_canRequest", false, true];

// Radio transmission raises alertness — PAVN intercepts comms
[_missionId] call vgm_s_fnc_director_onRadioTransmission;

// Only doing this calculation serverside, as the client doesn't have target box location data.
if (_lzPosition isEqualTo []) then {
    private _targetBox = _mission get "public" get "targetZone";
    private _lzs = [_targetBox] call vgm_g_fnc_missions_zones_getLzs;
    private _playerToExtract = leader _playerGroup;
    if (isNull _playerToExtract) then {
        _playerToExtract = selectRandom units _playerGroup;
    };
    private _lzsByDistance = _lzs apply {[_x distance2D _playerToExtract, _x]};
    _lzsByDistance sort true;

    _lzPosition = _lzsByDistance # 0 # 1;
    _useExactLzPosition = true;
};

if (_lzPosition isEqualTo []) exitWith {
    format ["Unable to extract, no LZ position found: %1", _missionId] call vgm_g_fnc_logError;
};

// ---- Check if selected LZ is compromised ----
private _extractLzKey = format ["%1_%2", _missionId, hashValue _lzPosition];
private _extractLzCompromised = _extractLzKey in vgm_s_compromisedLz_occupiedLzs;
private _extractDefenderData = if (_extractLzCompromised) then {
    vgm_s_compromisedLz_occupiedLzs get _extractLzKey
} else {
    nil
};

// spawn the helicopter, coming from the direction of the origin pos
private _helicopter = [_class] call vgm_s_fnc_missions_gameplay_createCrewedHelicopter;
_playerGroup setVariable ["vgm_missions_extraction_helicopter", _helicopter, true];

private _spawnPos = _lzPosition getPos [_distance, _lzPosition getDir _originPos];
_spawnPos set [2, 50];
_helicopter setPosATL _spawnPos;
_helicopter setDir random 360;

// Force NOE altitude during transit. scriptedLand uses a transit waypoint
// that respects this, then switches to landAt when close to the LZ.
_helicopter flyInHeight [25, true];

private _group = group _helicopter;

private _safeLzPositionATL = _lzPosition findEmptyPosition [0, 100, _class];
if (_useExactLzPosition || _safeLzPositionATL isEqualTo []) then {
    _safeLzPositionATL = _lzPosition;
};
_safeLzPositionATL set [2, 0];

private _helipad = createVehicle ["Land_vn_helipadempty_f", [0,0,0], [], 0, "NONE"];
_helipad setPosATL _safeLzPositionATL;
_helicopter setVariable ["vgm_mission_extraction_helipad", _helipad];

if (_extractLzCompromised) then {
    // ---- COMPROMISED LZ: Helicopter orbits at altitude until cleared ----
    format ["Extraction: LZ at %1 is compromised, helicopter will orbit", _lzPosition] call vgm_g_fnc_logInfo;

    // Voice line: "Negative on that LZ, seeing movement"
    private _pilot = driver _helicopter;
    [5, "extraction", "lz_compromised", false, _pilot] call vgm_s_fnc_voicelines_playDelayed;

    // Set helicopter to orbit at 200m altitude, 300m radius around LZ
    _helicopter flyInHeight [200, true];
    private _orbitWp = _group addWaypoint [_lzPosition, 0];
    _orbitWp setWaypointType "LOITER";
    _orbitWp setWaypointLoiterRadius 300;
    _orbitWp setWaypointLoiterType "CIRCLE";

    // Tag helicopter as in compromised orbit (for alternate LZ skill to detect)
    _helicopter setVariable ["vgm_compromisedLz_orbiting", true, true];
    _helicopter setVariable ["vgm_compromisedLz_defenderData", _extractDefenderData];
    _helicopter setVariable ["vgm_compromisedLz_lzKey", _extractLzKey];

    // Spawned monitoring script: wait for LZ cleared, alternate LZ, or timeout
    private _script = [_missionId, _mission, _helicopter, _helipad, _group, _lzPosition, _safeLzPositionATL, _extractLzKey] spawn {
        params ["_missionId", "_mission", "_helicopter", "_helipad", "_heliGroup", "_lzPosition", "_safeLzPositionATL", "_lzKey"];
        private _playerGroup = _mission get "public" get "group";
        private _timeoutTime = serverTime + vgm_s_compromisedLz_extractionTimeout;

        // Wait for the virtual squad to materialize so defender data has "units"
        private _defenderData = createHashMap;
        private _defenderUnits = [];
        private _waitedForSpawn = false;
        for "_wait" from 1 to 30 do {
            _defenderData = vgm_s_compromisedLz_occupiedLzs getOrDefault [_lzKey, createHashMap];
            _defenderUnits = _defenderData getOrDefault ["units", []];
            if (_defenderUnits isNotEqualTo []) exitWith {_waitedForSpawn = true};
            sleep 1;
        };

        if (_defenderUnits isEqualTo []) then {
            format ["Extraction: Compromised LZ defenders never spawned at %1, treating as cleared", _lzPosition] call vgm_g_fnc_logWarning;
        };

        // Ensure defenders are hostile (not captive) for extraction scenario
        private _defGroup = _defenderData getOrDefault ["group", grpNull];
        if (!isNull _defGroup) then {
            _defGroup setCaptive false;
            _defGroup setBehaviourStrong "COMBAT";
            _defGroup setCombatMode "RED";
            _defenderData set ["ambushTriggered", true];
            {_x setUnitPos "AUTO"} forEach (_defenderUnits select {alive _x});
        };

        private _outcome = ""; // "cleared", "alternate", "timeout"

        waitUntil {
            sleep 5;

            // Re-fetch units in case they were updated after initial read
            private _freshData = vgm_s_compromisedLz_occupiedLzs getOrDefault [_lzKey, createHashMap];
            private _freshUnits = _freshData getOrDefault ["units", _defenderUnits];
            if (_freshUnits isNotEqualTo []) then {_defenderUnits = _freshUnits};

            // Check if all tracked defenders are dead
            private _allDead = _defenderUnits isEqualTo [] || {{alive _x} count _defenderUnits == 0};
            if (_allDead) exitWith {_outcome = "cleared"; true};

            // Check if alternate LZ was selected (helicopter redirected)
            if !(_helicopter getVariable ["vgm_compromisedLz_orbiting", false]) exitWith {
                _outcome = "alternate"; true
            };

            // Check timeout
            if (serverTime > _timeoutTime) exitWith {_outcome = "timeout"; true};

            false
        };

        private _pilot = driver _helicopter;

        if (_outcome == "cleared") then {
            // LZ cleared — voice line and land
            format ["Extraction: Compromised LZ cleared at %1", _lzPosition] call vgm_g_fnc_logInfo;
            ["extraction", "lz_cleared", false, _pilot, true] call vgm_s_fnc_voicelines_play;

            _helicopter setVariable ["vgm_compromisedLz_orbiting", false, true];

            // Reset altitude from orbit (200m) so AI can descend for landing
            _helicopter flyInHeight [25, true];

            // Land at cleared LZ — scriptedLand handles waypoint cleanup and landAt
            [_helicopter] call vgm_s_fnc_missions_gameplay_extraction_scriptedLand;

            // Now run normal extraction flow (wait for land, board, depart)
            waitUntil {sleep 0.5; _helicopter getVariable ["vgm_missions_extractionLanded", false]};
            ["extraction", "arrival", false, _pilot, true] call vgm_s_fnc_voicelines_play;

            private _boardingConfirmed = false;
            while {!_boardingConfirmed} do {
                waitUntil {
                    private _alivePlayers = units _playerGroup select {alive _x && !(_x call vgm_g_fnc_medical_isUnconscious)};
                    private _everyoneBoarded = _alivePlayers findIf {!(_x in _helicopter)} == -1 && _alivePlayers isNotEqualTo [];
                    private _leaveNow = _helicopter getVariable ["vgm_missions_extraction_evacNow", false];
                    private _leaveAtTime = _helicopter getVariable ["vgm_missions_extraction_evacAt", -1];
                    _everyoneBoarded || _leaveNow || (_leaveAtTime isNotEqualTo -1 && serverTime > _leaveAtTime)
                };
                sleep 3;
                private _alivePlayers = units _playerGroup select {alive _x && !(_x call vgm_g_fnc_medical_isUnconscious)};
                private _forced = _helicopter getVariable ["vgm_missions_extraction_evacNow", false]
                    || {_helicopter getVariable ["vgm_missions_extraction_evacAt", -1] isNotEqualTo -1
                        && {serverTime > (_helicopter getVariable ["vgm_missions_extraction_evacAt", -1])}};
                _boardingConfirmed = _forced
                    || {_alivePlayers findIf {!(_x in _helicopter)} == -1 && _alivePlayers isNotEqualTo []};
            };

            _helicopter setVariable ["vgm_missions_extractionBoarded", true];

            // Check if mission targets are on board (snatch/bright_light/hatchet)
            private _missionForCheck = [_missionId] call vgm_s_fnc_missions_getById;
            if (!isNil "_missionForCheck") then {
                private _mType = (_missionForCheck get "parameters") getOrDefault ["missionType", "scouting"];
                if (_mType in ["prisoner_snatch", "bright_light", "hatchet_force"]) then {
                    private _targetOnBoard = call {
                        if (_mType == "prisoner_snatch") exitWith {
                            private _snatchData = [_missionId, "snatch"] call vgm_s_fnc_missions_getSystemNetmap;
                            private _officer = if (!isNil "_snatchData") then {_snatchData get "officer"} else {objNull};
                            (!isNull _officer && {_officer in _helicopter})
                        };
                        if (_mType == "bright_light") exitWith {
                            private _blData = [_missionId, "bright_light"] call vgm_s_fnc_missions_getSystemNetmap;
                            private _target = if (!isNil "_blData") then {_blData get "target"} else {objNull};
                            (!isNull _target && {_target in _helicopter})
                        };
                        if (_mType == "hatchet_force") exitWith {
                            private _hData = [_missionId, "hatchet"] call vgm_s_fnc_missions_getSystemNetmap;
                            private _reconTeam = if (!isNil "_hData") then {_hData getOrDefault ["reconTeam", []]} else {[]};
                            (_reconTeam findIf {alive _x && _x in _helicopter}) > -1
                        };
                        true
                    };
                    if (!_targetOnBoard) then {
                        format ["Extraction: Target NPC not on board for mission %1 (%2)", _missionId, _mType] call vgm_g_fnc_logWarning;
                    };
                };
            };

            _helicopter flyInHeight [100, true];
            _helicopter setCaptive false;

            ["vgm_missions_gameplay_extractionLiftOff", [_missionId, _helicopter], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;

            _pilot = driver _helicopter;
            [2, "extraction", "liftoff", false, _pilot, true] call vgm_s_fnc_voicelines_playDelayed;

            // Hatchet Force voice line
            private _missionForVoice = [_missionId] call vgm_s_fnc_missions_getById;
            if (!isNil "_missionForVoice") then {
                private _mTypeVoice = (_missionForVoice get "parameters") getOrDefault ["missionType", "scouting"];
                if (_mTypeVoice == "hatchet_force") then {
                    ["vgm_voice_hatchet_playerBirdAway", [_missionId], 2] call para_g_fnc_event_triggerTargets;
                };
            };

            format ["Extraction script successful (compromised LZ cleared): %1, %2", _missionId, _helicopter] call vgm_g_fnc_logInfo;

            private _departWp = _heliGroup addWaypoint [markerPos "vgm_mission_heli_despawn", 0];
            sleep 25;
            private _endType = ["FAILURE", "SUCCESS"] select (units _playerGroup findIf {_x in _helicopter} > -1);
            [_missionId, _endType] call vgm_s_fnc_missions_endMission;
            waitUntil {crew _helicopter findIf {isPlayer _x} == -1};
            sleep 25;
            {_helicopter deleteVehicleCrew _x} forEach units _helicopter;
            deleteVehicle _helicopter;
            deleteVehicle _helipad;

        } else { if (_outcome == "alternate") then {
            // Alternate LZ was selected — the alternate LZ skill already handles
            // redirecting the helicopter. We just need to continue with normal flow.
            format ["Extraction: Alternate LZ selected, leaving compromised LZ %1", _lzPosition] call vgm_g_fnc_logInfo;

            // Normal extraction flow from here (alternate LZ is guaranteed clean)
            waitUntil {sleep 0.5; _helicopter getVariable ["vgm_missions_extractionLanded", false]};
            _pilot = driver _helicopter;
            ["extraction", "arrival", false, _pilot, true] call vgm_s_fnc_voicelines_play;

            private _boardingConfirmed = false;
            while {!_boardingConfirmed} do {
                waitUntil {
                    private _alivePlayers = units _playerGroup select {alive _x && !(_x call vgm_g_fnc_medical_isUnconscious)};
                    private _everyoneBoarded = _alivePlayers findIf {!(_x in _helicopter)} == -1 && _alivePlayers isNotEqualTo [];
                    private _leaveNow = _helicopter getVariable ["vgm_missions_extraction_evacNow", false];
                    private _leaveAtTime = _helicopter getVariable ["vgm_missions_extraction_evacAt", -1];
                    _everyoneBoarded || _leaveNow || (_leaveAtTime isNotEqualTo -1 && serverTime > _leaveAtTime)
                };
                sleep 3;
                private _alivePlayers = units _playerGroup select {alive _x && !(_x call vgm_g_fnc_medical_isUnconscious)};
                private _forced = _helicopter getVariable ["vgm_missions_extraction_evacNow", false]
                    || {_helicopter getVariable ["vgm_missions_extraction_evacAt", -1] isNotEqualTo -1
                        && {serverTime > (_helicopter getVariable ["vgm_missions_extraction_evacAt", -1])}};
                _boardingConfirmed = _forced
                    || {_alivePlayers findIf {!(_x in _helicopter)} == -1 && _alivePlayers isNotEqualTo []};
            };

            _helicopter setVariable ["vgm_missions_extractionBoarded", true];

            // Check if mission targets are on board
            private _missionForCheck = [_missionId] call vgm_s_fnc_missions_getById;
            if (!isNil "_missionForCheck") then {
                private _mType = (_missionForCheck get "parameters") getOrDefault ["missionType", "scouting"];
                if (_mType in ["prisoner_snatch", "bright_light", "hatchet_force"]) then {
                    private _targetOnBoard = call {
                        if (_mType == "prisoner_snatch") exitWith {
                            private _snatchData = [_missionId, "snatch"] call vgm_s_fnc_missions_getSystemNetmap;
                            private _officer = if (!isNil "_snatchData") then {_snatchData get "officer"} else {objNull};
                            (!isNull _officer && {_officer in _helicopter})
                        };
                        if (_mType == "bright_light") exitWith {
                            private _blData = [_missionId, "bright_light"] call vgm_s_fnc_missions_getSystemNetmap;
                            private _target = if (!isNil "_blData") then {_blData get "target"} else {objNull};
                            (!isNull _target && {_target in _helicopter})
                        };
                        if (_mType == "hatchet_force") exitWith {
                            private _hData = [_missionId, "hatchet"] call vgm_s_fnc_missions_getSystemNetmap;
                            private _reconTeam = if (!isNil "_hData") then {_hData getOrDefault ["reconTeam", []]} else {[]};
                            (_reconTeam findIf {alive _x && _x in _helicopter}) > -1
                        };
                        true
                    };
                    if (!_targetOnBoard) then {
                        format ["Extraction: Target NPC not on board for mission %1 (%2)", _missionId, _mType] call vgm_g_fnc_logWarning;
                    };
                };
            };

            _helicopter flyInHeight [100, true];
            _helicopter setCaptive false;

            ["vgm_missions_gameplay_extractionLiftOff", [_missionId, _helicopter], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;
            _pilot = driver _helicopter;
            [2, "extraction", "liftoff", false, _pilot, true] call vgm_s_fnc_voicelines_playDelayed;

            private _missionForVoice = [_missionId] call vgm_s_fnc_missions_getById;
            if (!isNil "_missionForVoice") then {
                private _mTypeVoice = (_missionForVoice get "parameters") getOrDefault ["missionType", "scouting"];
                if (_mTypeVoice == "hatchet_force") then {
                    ["vgm_voice_hatchet_playerBirdAway", [_missionId], 2] call para_g_fnc_event_triggerTargets;
                };
            };

            format ["Extraction script successful (alternate LZ): %1, %2", _missionId, _helicopter] call vgm_g_fnc_logInfo;

            private _departWp = _heliGroup addWaypoint [markerPos "vgm_mission_heli_despawn", 0];
            sleep 25;
            private _endType = ["FAILURE", "SUCCESS"] select (units _playerGroup findIf {_x in _helicopter} > -1);
            [_missionId, _endType] call vgm_s_fnc_missions_endMission;
            waitUntil {crew _helicopter findIf {isPlayer _x} == -1};
            sleep 25;
            {_helicopter deleteVehicleCrew _x} forEach units _helicopter;
            deleteVehicle _helicopter;
            deleteVehicle _helipad;

        } else {
            // Timeout — helicopter RTBs, reset extraction cooldown
            format ["Extraction: Timeout at compromised LZ %1, helicopter RTB", _lzPosition] call vgm_g_fnc_logInfo;

            _pilot = driver _helicopter;
            ["extraction", "lz_timeout", false, _pilot, true] call vgm_s_fnc_voicelines_play;

            _helicopter setVariable ["vgm_compromisedLz_orbiting", false, true];

            // Clear waypoints and send helicopter home
            while {count waypoints _heliGroup > 0} do {
                deleteWaypoint [_heliGroup, 0];
            };

            _helicopter flyInHeight [100, true];
            private _departWp = _heliGroup addWaypoint [markerPos "vgm_mission_heli_despawn", 0];

            // Reset extraction cooldown so players can call again
            _playerGroup setVariable ["vgm_missions_extraction_canRequest", true, true];

            format ["Extraction: Cooldown reset for mission %1 after compromised LZ timeout", _missionId] call vgm_g_fnc_logInfo;

            // Cleanup helicopter after departure
            sleep 60;
            waitUntil {sleep 5; crew _helicopter findIf {isPlayer _x} == -1};
            {_helicopter deleteVehicleCrew _x} forEach units _helicopter;
            deleteVehicle _helicopter;
            deleteVehicle _helipad;
        }; };
    };

    _group setVariable ["vgm_missions_extractionScript", _script];

    ["vgm_missions_gameplay_extractionStarted", [_missionId, +_safeLzPositionATL, _helicopter], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;

    // Voice line: extraction inbound with warning about LZ
    private _pilot = driver _helicopter;
    [5, "extraction", "inbound", false, _pilot] call vgm_s_fnc_voicelines_playDelayed;

} else {
    // ---- NORMAL EXTRACTION (LZ not compromised) ----
    [_helicopter] call vgm_s_fnc_missions_gameplay_extraction_scriptedLand;

    private _script = [_missionId, _mission, _helicopter, _helipad] spawn {
        params ["_missionId", "_mission", "_helicopter", "_helipad"];
        private _playerGroup = _mission get "public" get "group";

        // Wait for helicopter to land, then play arrival voice line
        waitUntil {sleep 0.5; _helicopter getVariable ["vgm_missions_extractionLanded", false]};
        private _pilot = driver _helicopter;
        ["extraction", "arrival", false, _pilot, true] call vgm_s_fnc_voicelines_play;

        // Wait for all alive players to board, with 3s confirmation to prevent
        // single-frame get-in/get-out from triggering premature departure
        private _boardingConfirmed = false;
        while {!_boardingConfirmed} do {
            waitUntil {
                private _alivePlayers = units _playerGroup select {alive _x && !(_x call vgm_g_fnc_medical_isUnconscious)};
                private _everyoneBoarded = _alivePlayers findIf {!(_x in _helicopter)} == -1 && _alivePlayers isNotEqualTo [];
                private _leaveNow = _helicopter getVariable ["vgm_missions_extraction_evacNow", false];
                private _leaveAtTime = _helicopter getVariable ["vgm_missions_extraction_evacAt", -1];

                _everyoneBoarded || _leaveNow || (_leaveAtTime isNotEqualTo -1 && serverTime > _leaveAtTime)
            };
            sleep 3;
            private _alivePlayers = units _playerGroup select {alive _x && !(_x call vgm_g_fnc_medical_isUnconscious)};
            private _forced = _helicopter getVariable ["vgm_missions_extraction_evacNow", false]
                || {_helicopter getVariable ["vgm_missions_extraction_evacAt", -1] isNotEqualTo -1
                    && {serverTime > (_helicopter getVariable ["vgm_missions_extraction_evacAt", -1])}};
            _boardingConfirmed = _forced
                || {_alivePlayers findIf {!(_x in _helicopter)} == -1 && _alivePlayers isNotEqualTo []};
        };

        _helicopter setVariable ["vgm_missions_extractionBoarded", true];

        // Check if mission targets are on board (snatch/bright_light/hatchet)
        private _missionForCheck = [_missionId] call vgm_s_fnc_missions_getById;
        if (!isNil "_missionForCheck") then {
            private _mType = (_missionForCheck get "parameters") getOrDefault ["missionType", "scouting"];
            if (_mType in ["prisoner_snatch", "bright_light", "hatchet_force"]) then {
                private _targetOnBoard = call {
                    if (_mType == "prisoner_snatch") exitWith {
                        private _snatchData = [_missionId, "snatch"] call vgm_s_fnc_missions_getSystemNetmap;
                        private _officer = if (!isNil "_snatchData") then {_snatchData get "officer"} else {objNull};
                        (!isNull _officer && {_officer in _helicopter})
                    };
                    if (_mType == "bright_light") exitWith {
                        private _blData = [_missionId, "bright_light"] call vgm_s_fnc_missions_getSystemNetmap;
                        private _target = if (!isNil "_blData") then {_blData get "target"} else {objNull};
                        (!isNull _target && {_target in _helicopter})
                    };
                    if (_mType == "hatchet_force") exitWith {
                        private _hData = [_missionId, "hatchet"] call vgm_s_fnc_missions_getSystemNetmap;
                        private _reconTeam = if (!isNil "_hData") then {_hData getOrDefault ["reconTeam", []]} else {[]};
                        (_reconTeam findIf {alive _x && _x in _helicopter}) > -1
                    };
                    true
                };
                if (!_targetOnBoard) then {
                    format ["Extraction: Target NPC not on board for mission %1 (%2)", _missionId, _mType] call vgm_g_fnc_logWarning;
                };
            };
        };

        _helicopter flyInHeight [100, true];
        _helicopter setCaptive false;

        ["vgm_missions_gameplay_extractionLiftOff", [_missionId, _helicopter], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;

        // Voice line: liftoff ("Get us outta this hell-hole")
        _pilot = driver _helicopter;
        [2, "extraction", "liftoff", false, _pilot, true] call vgm_s_fnc_voicelines_playDelayed;

        // Hatchet Force: "you guys sure know how to throw a party" on player bird liftoff
        private _missionForVoice = [_missionId] call vgm_s_fnc_missions_getById;
        if (!isNil "_missionForVoice") then {
            private _mTypeVoice = (_missionForVoice get "parameters") getOrDefault ["missionType", "scouting"];
            if (_mTypeVoice == "hatchet_force") then {
                ["vgm_voice_hatchet_playerBirdAway", [_missionId], 2] call para_g_fnc_event_triggerTargets;
            };
        };

        format ["Extraction script successful: %1, %2", _missionId, _helicopter] call vgm_g_fnc_logInfo;

        private _landWp = group _helicopter addWaypoint [markerPos "vgm_mission_heli_despawn", 0];
        sleep 25;
        private _endType = ["FAILURE", "SUCCESS"] select (units _playerGroup findIf {_x in _helicopter} > -1);
        [_missionId, _endType] call vgm_s_fnc_missions_endMission;
        waitUntil {crew _helicopter findIf {isPlayer _x} == -1};
        sleep 25;
        {_helicopter deleteVehicleCrew _x} forEach units _helicopter;
        deleteVehicle _helicopter;
        deleteVehicle _helipad;
    };

    _group setVariable ["vgm_missions_extractionScript", _script];

    ["vgm_missions_gameplay_extractionStarted", [_missionId, +_safeLzPositionATL, _helicopter], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;

    // Voice line: extraction inbound ("slicks inbound")
    private _pilot = driver _helicopter;
    [5, "extraction", "inbound", false, _pilot] call vgm_s_fnc_voicelines_playDelayed;
};

// clean up extraction if mission fails
call {
    if (isNil "vgm_missions_gameplay_extractionMissionEndedHandlers") then {
        vgm_missions_gameplay_extractionMissionEndedHandlers = createHashMap;
    };

    private _ehEndedId = ["vgm_mission_ended", [[_helicopter, _group, _missionId], {
        (_this#0) params ["_missionId", "_endType"];
        (_this#1) params ["_helicopter", "_group", "_targetMissionId"];
        if (_missionId != _targetMissionId) exitWith {};

        private _ehId = vgm_missions_gameplay_extractionMissionEndedHandlers deleteAt _missionId;
        [_ehId] call para_g_fnc_event_unsubscribe;

        if (_endType != "FAILURE") exitWith {};

        format ["Extraction script cleanup, mission failed: %1, %2, %3", _missionId, _helicopter, _group] call vgm_g_fnc_logInfo;

        terminate (_group getVariable ["vgm_missions_extractionScript", scriptNull]);

        {_helicopter deleteVehicleCrew _x} forEach units _helicopter;
        deleteVehicle (_helicopter getVariable ["vgm_mission_extraction_helipad", objNull]);
        deleteVehicle _helicopter;

    }]] call para_g_fnc_event_subscribeLocal;
    vgm_missions_gameplay_extractionMissionEndedHandlers set [_missionId, _ehEndedId];
};

_helicopter // return
