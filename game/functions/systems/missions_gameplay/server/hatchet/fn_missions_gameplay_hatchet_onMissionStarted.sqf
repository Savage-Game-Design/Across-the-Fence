/*
    File: fn_missions_gameplay_hatchet_onMissionStarted.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Handles mission start for Hatchet Force type. Spawns a compromised
        recon team under fire from PAVN squads, with hot or cold LZ insertion.
        Enemy count scales with player count.

    Parameter(s):
        _missionId - Id of the mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_missionId] call vgm_s_fnc_missions_gameplay_hatchet_onMissionStarted
 */

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {
    format ["Hatchet: Mission does not exist: %1", _missionId] call vgm_g_fnc_logError;
};

private _missionType = (_mission get "parameters") getOrDefault ["missionType", "scouting"];
if (_missionType != "hatchet_force") exitWith {};

private _missionPublic = _mission get "public";
private _playerGroup = _missionPublic get "group";
private _targetZone = _missionPublic get "targetZone";
private _hatchetNetmap = [_missionId, "hatchet"] call vgm_s_fnc_missions_getSystemNetmap;
private _insertionType = _hatchetNetmap get "insertionType";

private _sites = +(_targetZone call vgm_s_fnc_missions_zones_getSites);
private _startPosASL = _missionPublic get "startPosASL";
private _startPosATL = ASLToATL _startPosASL;

// Player count for scaling
private _playerCount = count (units _playerGroup select {alive _x && isPlayer _x});

// Pick recon team position based on insertion type
// NOTE: This fires AFTER infil already launched the helicopter, so we can't
// override the LZ. Instead we place the recon team relative to the existing LZ.
private _zoneMarker = _targetZone call vgm_g_fnc_missions_getZoneMarker;
private _reconPos = [0,0,0];

if (_insertionType == "hot") then {
    // Hot LZ: recon team IS at the LZ — players land right on them
    _reconPos = +_startPosATL;
    _reconPos set [2, 0];
} else {
    // Cold LZ: recon team 300-600m from LZ, inside the AO
    private _attempts = 0;
    while {_attempts < 50} do {
        _reconPos = _startPosATL getPos [300 + random 300, random 360];
        _reconPos set [2, 0];
        if (_reconPos inArea _zoneMarker) exitWith {};
        _attempts = _attempts + 1;
    };
    if !(_reconPos inArea _zoneMarker) then {
        _reconPos = _startPosATL getPos [300, random 360];
        _reconPos set [2, 0];
        format ["Hatchet: Could not find recon position inside AO after %1 attempts, using closest fallback", _attempts] call vgm_g_fnc_logWarning;
    };
};

// Spawn compromised recon team (3 friendly SOG AI NPCs)
private _reconClasses = ["vn_b_men_sog_01", "vn_b_men_sog_02", "vn_b_men_sog_06"];
private _reconGrp = createGroup west;
_reconGrp deleteGroupWhenEmpty true;
_reconGrp setBehaviourStrong "COMBAT";
_reconGrp setCombatMode "RED";

private _reconTeam = [];
{
    private _unit = _reconGrp createUnit [_x, _reconPos, [], 5, "NONE"];
    _unit setVariable ["vgm_hatchet_reconTeam", true, true];
    _unit setVariable ["vgm_hatchet_missionId", _missionId, true];
    _unit setSkill 1;

    // Start with invulnerability (Phase 1)
    _unit allowDamage false;

    // Enable SOG Advanced Revive on recon AI — allows players to bandage them back up
    private _hdEH = _unit addEventHandler ["HandleDamage", {_this call vn_fnc_revive_handledamage}];
    _unit setVariable ["vn_revive_event_handledamage", _hdEH];
    // AI need setUnconscious forced since SOG coreinit only does it for players
    _unit addEventHandler ["HandleDamage", {
        params ["_unit"];
        if (_unit getVariable ["vn_revive_incapacitated", false] && {!isPlayer _unit}) then {
            _unit setUnconscious true;
            _unit setCaptive true;
        };
    }];

    // Monitor for SOG revive clearing incapacitated — restore AI state when revived
    [_unit] spawn {
        params ["_unit"];
        while {alive _unit} do {
            waitUntil {sleep 1; !alive _unit || _unit getVariable ["vn_revive_incapacitated", false]};
            if (!alive _unit) exitWith {};
            waitUntil {sleep 1; !alive _unit || !(_unit getVariable ["vn_revive_incapacitated", false])};
            if (!alive _unit) exitWith {};
            _unit setUnconscious false;
            _unit setCaptive false;
            _unit setDamage 0.5;
            _unit setBehaviour "COMBAT";
            _unit setCombatMode "RED";
        };
    };

    _reconTeam pushBack _unit;
} forEach _reconClasses;

// Spawn 3-6 dead SOG bodies around recon team (fallen teammates)
// Spawn alive then kill so they ragdoll naturally
private _deadBodyClasses = ["vn_b_men_sog_03", "vn_b_men_sog_04", "vn_b_men_sog_05", "vn_b_men_sog_07", "vn_b_men_sog_08", "vn_b_men_sog_09"];
private _deadCount = 3 + floor random 4; // 3-6
private _deadGrp = createGroup west;
_deadGrp deleteGroupWhenEmpty true;
for "_i" from 1 to _deadCount do {
    private _bodyPos = _reconPos getPos [3 + random 10, random 360];
    private _body = _deadGrp createUnit [selectRandom _deadBodyClasses, _bodyPos, [], 1, "NONE"];
    _body disableAI "ALL";
    _body setDamage [1, true];
};

// Set up recon team to defend position
private _wp = _reconGrp addWaypoint [_reconPos, 0];
_wp setWaypointType "HOLD";

// Spawn PAVN attackers around recon team — scales with player count
// Base: 6 squads for 1-2 players, +1 per 2 additional players
private _squadCount = 6 + floor (_playerCount / 2);
_squadCount = _squadCount min 10;

private _enemyClasses = ["vn_o_men_nva_02", "vn_o_men_nva_03", "vn_o_men_nva_04", "vn_o_men_nva_05", "vn_o_men_nva_06", "vn_o_men_nva_07", "vn_o_men_nva_10"];
private _spawnedEnemies = [];

for "_i" from 1 to _squadCount do {
    private _enemyGrp = createGroup east;
    _enemyGrp deleteGroupWhenEmpty true;

    // Squad size scales: 4-5 base, +1 per 3 players
    private _squadSize = 4 + floor (_playerCount / 3);
    _squadSize = _squadSize min 8;

    private _spawnPos = _reconPos getPos [80 + random 70, (_i * (360 / _squadCount)) + random 30];
    for "_j" from 1 to _squadSize do {
        private _unit = _enemyGrp createUnit [selectRandom _enemyClasses, _spawnPos, [], 10, "NONE"];
        _spawnedEnemies pushBack _unit;
    };

    // Attack the recon position
    _enemyGrp setBehaviourStrong "COMBAT";
    _enemyGrp setCombatMode "RED";
    private _attackWp = _enemyGrp addWaypoint [_reconPos, 0];
    _attackWp setWaypointType "SAD";
};

// Store references
[_hatchetNetmap, "reconTeam", _reconTeam] call para_s_fnc_netmap_set;
[_hatchetNetmap, "spawnedEnemies", _spawnedEnemies] call para_s_fnc_netmap_set;
[_hatchetNetmap, "reconPos", _reconPos] call para_s_fnc_netmap_set;
[_hatchetNetmap, "reconGroup", _reconGrp] call para_s_fnc_netmap_set;

// Spike alertness for Mission Director
private _directorData = _mission getOrDefault ["director", createHashMap];
if (_directorData isNotEqualTo createHashMap) then {
    private _alertSpike = if (_insertionType == "hot") then {50 + random 10} else {20 + random 10};
    [_directorData, _alertSpike] call vgm_s_fnc_director_addAlertness;
};

// Fire briefing voice line immediately (plays while still in helicopter)
// NOTE: No insertion LZ voiceline here — the base mission system already plays one
["vgm_voice_hatchet_briefing", [_missionId], 2] call para_g_fnc_event_triggerTargets;

// Create tasks (short delay so they appear in the helicopter)
[_mission, _missionId, _reconPos, _playerGroup, _insertionType] spawn {
    params ["_mission", "_missionId", "_reconPos", "_playerGroup", "_insertionType"];
    sleep 3;

    private _gridRef = (_reconPos call BIS_fnc_posToGrid) joinString " ";
    private _rtName = selectRandom ["Asp", "Python", "Adder", "Mamba", "Cobra", "Viper", "Sidewinder"];
    private _parentTaskId = format ["vgm_hatchet_%1", _missionId];

    // Store RT name for voice lines
    private _hatchetNetmap = [_missionId, "hatchet"] call vgm_s_fnc_missions_getSystemNetmap;
    [_hatchetNetmap, "rtName", _rtName] call para_s_fnc_netmap_set;

    [
        _playerGroup,
        _parentTaskId,
        [
            format [localize "STR_VGM_MISSIONS_HATCHET_TASK_DESCRIPTION", _rtName, _gridRef],
            format [localize "STR_VGM_MISSIONS_HATCHET_TASK_TITLE", _rtName]
        ],
        _reconPos,
        "ASSIGNED",
        -1,
        true,
        "attack"
    ] call BIS_fnc_taskCreate;

    if (_insertionType == "hot") then {
        // Hot LZ: players land directly on the team — skip "reach", go straight to "secure"
        [
            _playerGroup,
            [format ["%1_reach", _parentTaskId], _parentTaskId],
            [
                format [localize "STR_VGM_MISSIONS_HATCHET_SUBTASK_REACH_DESC", _rtName, _gridRef],
                format [localize "STR_VGM_MISSIONS_HATCHET_SUBTASK_REACH_TITLE", _rtName]
            ],
            _reconPos,
            "SUCCEEDED",
            -1,
            false,
            "move"
        ] call BIS_fnc_taskCreate;

        [
            _playerGroup,
            [format ["%1_secure", _parentTaskId], _parentTaskId],
            [
                localize "STR_VGM_MISSIONS_HATCHET_SUBTASK_SECURE_DESC",
                localize "STR_VGM_MISSIONS_HATCHET_SUBTASK_SECURE_TITLE"
            ],
            _reconPos,
            "ASSIGNED",
            -1,
            false,
            "defend"
        ] call BIS_fnc_taskCreate;
    } else {
        // Cold LZ: full task chain — reach, then secure
        [
            _playerGroup,
            [format ["%1_reach", _parentTaskId], _parentTaskId],
            [
                format [localize "STR_VGM_MISSIONS_HATCHET_SUBTASK_REACH_DESC", _rtName, _gridRef],
                format [localize "STR_VGM_MISSIONS_HATCHET_SUBTASK_REACH_TITLE", _rtName]
            ],
            _reconPos,
            "ASSIGNED",
            -1,
            false,
            "move"
        ] call BIS_fnc_taskCreate;

        [
            _playerGroup,
            [format ["%1_secure", _parentTaskId], _parentTaskId],
            [
                localize "STR_VGM_MISSIONS_HATCHET_SUBTASK_SECURE_DESC",
                localize "STR_VGM_MISSIONS_HATCHET_SUBTASK_SECURE_TITLE"
            ],
            _reconPos,
            "CREATED",
            -1,
            false,
            "defend"
        ] call BIS_fnc_taskCreate;
    };

    // Subtask 3: Extract
    [
        _playerGroup,
        [format ["%1_extract", _parentTaskId], _parentTaskId],
        [
            localize "STR_VGM_MISSIONS_HATCHET_SUBTASK_EXTRACT_DESC",
            localize "STR_VGM_MISSIONS_HATCHET_SUBTASK_EXTRACT_TITLE"
        ],
        _reconPos,
        "CREATED",
        -1,
        false,
        "getin"
    ] call BIS_fnc_taskCreate;
};

// Play ambient gunfire sounds for cold LZ (from recon position)
if (_insertionType == "cold") then {
    [_reconPos, _playerGroup] spawn {
        params ["_reconPos", "_playerGroup"];
        sleep 15;
        // Loop gunfire sounds at recon position so players can hear the fight
        for "_i" from 1 to 30 do {
            private _soundPos = _reconPos getPos [random 20, random 360];
            _soundPos set [2, 1];
            playSound3D ["a3\sounds_f\weapons\rifles\ak74\single_4.wss", objNull, false, _soundPos, 5, 1, 800];
            sleep (0.5 + random 2);
            playSound3D ["a3\sounds_f\weapons\rifles\m16\single_1.wss", objNull, false, _reconPos, 4, 1, 600];
            sleep (1 + random 3);
        };
    };
};

// Spawn CAS gunships on station — orbiting near the recon team
[_reconPos, _missionId] spawn {
    params ["_reconPos", "_missionId"];

    private _casClasses = ["vn_b_air_ah1g_04", "vn_b_air_ah1g_05", "vn_b_air_ah1g_06"];
    private _casUnits = [];

    for "_i" from 1 to 2 do {
        private _grp = createGroup west;
        _grp deleteGroupWhenEmpty true;

        private _heli = createVehicle [selectRandom _casClasses, [0,0,0], [], 0, "FLY"];
        createVehicleCrew _heli;
        _heli allowDamage false;
        {_x allowDamage false} forEach crew _heli;

        // Position orbiting at altitude around the recon team
        private _orbitPos = _reconPos getPos [400 + random 200, _i * 180];
        _orbitPos set [2, 150 + random 50];
        _heli setPosATL _orbitPos;

        // Set up SAD waypoint so they engage enemies near recon team
        private _wp = (group driver _heli) addWaypoint [_reconPos, 200];
        _wp setWaypointType "SAD";
        _wp setWaypointLoiterType "CIRCLE_L";
        _wp setWaypointLoiterRadius 400;
        (group driver _heli) setBehaviourStrong "COMBAT";
        (group driver _heli) setCombatMode "RED";

        _casUnits pushBack _heli;
    };

    // Clean up CAS when mission ends
    private _ehId = [format ["vgm_mission_ended"], [[_casUnits, _missionId], {
        (_this#0) params ["_endMissionId"];
        (_this#1) params ["_casUnits", "_targetMissionId"];
        if (_endMissionId != _targetMissionId) exitWith {};
        {
            {_x deleteVehicleCrew _x} forEach crew _x;
            deleteVehicle _x;
        } forEach _casUnits;
    }]] call para_g_fnc_event_subscribeLocal;
};

// Start monitoring script
[_missionId, _reconTeam, _playerGroup, _reconPos, _insertionType, _spawnedEnemies, _reconGrp] spawn vgm_s_fnc_missions_gameplay_hatchet_monitorTeam;

format ["Hatchet: Recon team spawned at %1 (%2 LZ) with %3 enemy squads for mission %4", _reconPos, _insertionType, _squadCount, _missionId] call vgm_g_fnc_logInfo;
