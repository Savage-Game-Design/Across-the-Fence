/*
    File: fn_missions_gameplay_bright_light_onMissionStarted.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-05
    Public: No

    Description:
        Handles mission start for Bright Light Rescue type (always downed pilot).
        Creates immersive crash scene with two sub-variants:
          Variant A (pilot_at_crash) — pilot unconscious near wreck, NVA assault on approach.
          Variant B (pilot_captured) — pilot gone, intel at crash, pilot held at nearby site.
        Patrol count scales with player count.

    Parameter(s):
        _missionId - Id of the mission [NUMBER]

    Returns:
        Nothing

    Example(s):
        [_missionId] call vgm_s_fnc_missions_gameplay_bright_light_onMissionStarted
 */

params ["_missionId"];

private _mission = [_missionId] call vgm_s_fnc_missions_getById;
if (isNil "_mission") exitWith {
    format ["Bright Light: Mission does not exist: %1", _missionId] call vgm_g_fnc_logError;
};

private _missionType = (_mission get "parameters") getOrDefault ["missionType", "scouting"];
if (_missionType != "bright_light") exitWith {};

private _missionPublic = _mission get "public";
private _playerGroup = _missionPublic get "group";
private _targetZone = _missionPublic get "targetZone";
private _blNetmap = [_missionId, "bright_light"] call vgm_s_fnc_missions_getSystemNetmap;
private _rescueType = _blNetmap get "rescueType";

private _sites = +(_targetZone call vgm_s_fnc_missions_zones_getSites);
private _startPosASL = _missionPublic get "startPosASL";
private _startPosATL = ASLToATL _startPosASL;

// Player count for scaling
private _playerCount = count (units _playerGroup select {alive _x && isPlayer _x});

private _target = objNull;
private _targetPos = [0,0,0];
private _wreck = objNull;
private _spawnedUnits = [];
private _zoneMarker = _targetZone call vgm_g_fnc_missions_getZoneMarker;

if (_rescueType == "downed_pilot") then {
    // --- DOWNED PILOT: Immersive crash scene with two sub-variants ---

    // Select sub-variant: A = pilot at crash, B = pilot captured
    private _pilotVariant = if (_sites isEqualTo []) then {
        "pilot_at_crash"
    } else {
        selectRandom ["pilot_at_crash", "pilot_captured"]
    };
    [_blNetmap, "pilotVariant", _pilotVariant] call para_s_fnc_netmap_set;

    // --- Find crash position: 300-600m from any site, inside the AO, clear of rocks/buildings ---
    private _crashPos = [0,0,0];
    private _foundCrashPos = false;
    for "_attempt" from 1 to 60 do {
        if (_foundCrashPos) exitWith {};
        private _refSite = selectRandom _sites;
        private _refPos = if (!isNil "_refSite") then {_refSite get "pos"} else {_startPosATL};
        private _candidatePos = _refPos getPos [300 + random 300, random 360];
        _candidatePos set [2, 0];
        if (!(_candidatePos inArea _zoneMarker) || {surfaceIsWater _candidatePos}) then {continue};
        // Reject steep terrain (slope > 15 degrees)
        private _normal = surfaceNormal _candidatePos;
        if ((_normal select 2) < 0.96) then {continue};
        // Reject positions near rocks, buildings, or large objects within 15m
        private _nearObjs = nearestTerrainObjects [_candidatePos, ["ROCK", "BUILDING", "WALL", "HOUSE"], 15, false];
        if (_nearObjs isNotEqualTo []) then {continue};
        // Also check for non-terrain objects (placed rocks, structures)
        private _nearVehicles = nearestObjects [_candidatePos, ["Rock", "Building", "House", "Strategic"], 15];
        if (_nearVehicles isNotEqualTo []) then {continue};
        _crashPos = _candidatePos;
        _foundCrashPos = true;
    };
    if (!_foundCrashPos) then {
        // Fallback: use zone center offset toward a site
        private _refPos = if (_sites isNotEqualTo []) then {(selectRandom _sites) get "pos"} else {_startPosATL};
        _crashPos = _refPos getPos [100 + random 200, random 360];
        _crashPos set [2, 0];
        if !(_crashPos inArea _zoneMarker) then {
            _crashPos = markerPos _zoneMarker;
            _crashPos set [2, 0];
        };
        format ["Bright Light: Could not find safe crash position after 60 attempts, using fallback %1", _crashPos] call vgm_g_fnc_logWarning;
    };

    _targetPos = _crashPos;
    [_blNetmap, "crashPos", _crashPos] call para_s_fnc_netmap_set;

    // --- Create crash scene (shared function) ---
    private _sceneResult = [_crashPos, random 360] call vgm_s_fnc_bright_light_createCrashScene;
    private _sceneObjects = _sceneResult get "sceneObjects";
    private _hiddenTerrainObjects = _sceneResult get "hiddenTerrainObjects";
    _wreck = _sceneResult get "wreck";

    // --- Variant-specific spawning ---
    if (_pilotVariant == "pilot_at_crash") then {
        // Variant A: pilot unconscious 10-30m from wreck
        private _pilotPos = _crashPos getPos [10 + random 20, random 360];
        private _grp = createGroup west;
        _grp deleteGroupWhenEmpty true;
        _target = _grp createUnit ["vn_b_men_aircrew_01", _pilotPos, [], 0, "NONE"];

        format ["Bright Light: Variant A — pilot at crash %1 for mission %2", _crashPos, _missionId] call vgm_g_fnc_logInfo;
    } else {
        // Variant B: pilot captured — held at nearest site
        private _closestSite = _sites select 0;
        private _closestDist = 1e10;
        {
            private _sitePos = _x get "pos";
            private _dist = _crashPos distance2D _sitePos;
            if (_dist < _closestDist) then {
                _closestDist = _dist;
                _closestSite = _x;
            };
        } forEach _sites;

        private _sitePos = _closestSite get "pos";
        [_blNetmap, "sitePos", _sitePos] call para_s_fnc_netmap_set;

        // Pilot at the site, guarded (no helmet — it's at the crash)
        private _pilotPos = _sitePos getPos [5 + random 10, random 360];
        private _grp = createGroup west;
        _grp deleteGroupWhenEmpty true;
        _target = _grp createUnit ["vn_b_men_aircrew_01", _pilotPos, [], 0, "NONE"];
        removeHeadgear _target;

        // NVA investigators at crash (2-3 soldiers)
        private _investigatorClasses = ["vn_o_men_nva_02", "vn_o_men_nva_03", "vn_o_men_nva_04"];
        private _invGrp = createGroup east;
        _invGrp deleteGroupWhenEmpty true;
        private _invCount = 2 + floor random 2;
        for "_i" from 1 to _invCount do {
            private _invPos = _crashPos getPos [5 + random 10, random 360];
            private _unit = _invGrp createUnit [selectRandom _investigatorClasses, _invPos, [], 0, "NONE"];
            _spawnedUnits pushBack _unit;
        };
        _invGrp setBehaviourStrong "AWARE";
        _invGrp setCombatMode "RED";

        // NVA guards at site (3-4 soldiers)
        private _guardClasses = ["vn_o_men_nva_02", "vn_o_men_nva_05", "vn_o_men_nva_06", "vn_o_men_nva_07"];
        private _guardGrp = createGroup east;
        _guardGrp deleteGroupWhenEmpty true;
        private _guardCount = 3 + floor random 2;
        for "_i" from 1 to _guardCount do {
            private _guardPos = _sitePos getPos [10 + random 20, random 360];
            private _unit = _guardGrp createUnit [selectRandom _guardClasses, _guardPos, [], 0, "NONE"];
            _spawnedUnits pushBack _unit;
        };
        _guardGrp setBehaviourStrong "AWARE";
        _guardGrp setCombatMode "RED";
        private _wp = _guardGrp addWaypoint [_sitePos, 15];
        _wp setWaypointType "GUARD";

        // Intel object at crash — pilot helmet on the ground (10-15m out, clear of wreck/fire)
        private _helmetPos = _crashPos getPos [10 + random 5, random 360];
        _helmetPos set [2, 0];
        private _intelObj = createVehicle ["GroundWeaponHolder", [0,0,0], [], 0, "CAN_COLLIDE"];
        _intelObj setPosATL _helmetPos;
        _intelObj addItemCargoGlobal ["vn_b_helmet_sph4", 1];
        _sceneObjects pushBack _intelObj;

        // Blood trail from crash to capture site (every 5-15m)
        private _bloodTrail = [];
        private _trailDist = _crashPos distance2D _sitePos;
        private _trailDir = _crashPos getDir _sitePos;
        private _traveled = 5 + random 5;
        while {_traveled < _trailDist - 10} do {
            private _bloodPos = _crashPos getPos [_traveled, _trailDir + (-5 + random 10)];
            _bloodPos set [2, 0];
            private _bloodObj = createVehicle ["BloodSplat_01_Large_New_F", _bloodPos, [], 0, "CAN_COLLIDE"];
            _bloodObj setDir random 360;
            _bloodObj setVectorUp surfaceNormal _bloodPos;
            _bloodTrail pushBack _bloodObj;
            _sceneObjects pushBack _bloodObj;
            // Register with hints system on all clients for focus mode glint
            [_bloodObj, [_sitePos]] remoteExec ["vgm_c_fnc_sites_hints_initObject", 0, true];
            _traveled = _traveled + 5 + random 10;
        };
        [_blNetmap, "bloodTrail", _bloodTrail] call para_s_fnc_netmap_set;

        // Hold action on intel object — search for intel (client-side via remoteExec)
        // Store missionId on the object so the completion code can reference it
        _intelObj setVariable ["vgm_bright_light_missionId", _missionId, true];

        [
            _intelObj,
            format ["<t color='#ed872d'>%1</t>", "Inspect Helmet"],
            "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
            "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa",
            "true",
            "true",
            {},
            {},
            {
                params ["_target", "_caller", "_actionId"];
                [_target, _actionId] remoteExec ["BIS_fnc_holdActionRemove", 0, _target];
                // Notify server that intel was gathered
                private _mid = _target getVariable ["vgm_bright_light_missionId", -1];
                ["vgm_bright_light_intelGathered", [_mid]] call para_g_fnc_event_triggerServer;
                hint "Pilot's helmet — blood trail leads away from the crash.";
            },
            {},
            nil,
            8,
            100,
            true,
            false
        ] remoteExec ["BIS_fnc_holdActionAdd", 0, _intelObj];

        format ["Bright Light: Variant B — pilot captured at site %1, crash at %2 for mission %3", _sitePos, _crashPos, _missionId] call vgm_g_fnc_logInfo;
    };

    // Store scene objects
    [_blNetmap, "sceneObjects", _sceneObjects] call para_s_fnc_netmap_set;
    [_blNetmap, "hiddenTerrainObjects", _hiddenTerrainObjects] call para_s_fnc_netmap_set;

    // Set 20-minute deadline timer
    private _deadline = serverTime + 1200;
    [_blNetmap, "missionDeadline", _deadline] call para_s_fnc_netmap_set;

};

// Setup rescue target
_target setCaptive true;
_target setUnconscious true;
_target setVariable ["vgm_bright_light_target", true, true];
_target setVariable ["vgm_bright_light_missionId", _missionId, true];

// SOG Advanced Revive integration — allows players to bandage the pilot back up
private _hdEH = _target addEventHandler ["HandleDamage", {_this call vn_fnc_revive_handledamage}];
_target setVariable ["vn_revive_event_handledamage", _hdEH];
_target addEventHandler ["HandleDamage", {
    params ["_unit"];
    if (_unit getVariable ["vn_revive_incapacitated", false] && {!isPlayer _unit}) then {
        _unit setUnconscious true;
        _unit setCaptive true;
    };
}];

// Mark as incapacitated for SOG revive UI (bandage / pick up / load)
_target setVariable ["vn_revive_incapacitated", true, true];
[_target] call vn_fnc_revive_actions_local;

// Monitor for SOG revive clearing incapacitated — restore AI state when revived
[_target] spawn {
    params ["_unit"];
    while {alive _unit} do {
        waitUntil {sleep 1; !alive _unit || _unit getVariable ["vn_revive_incapacitated", false]};
        if (!alive _unit) exitWith {};
        waitUntil {sleep 1; !alive _unit || !(_unit getVariable ["vn_revive_incapacitated", false])};
        if (!alive _unit) exitWith {};
        _unit setUnconscious false;
        _unit setCaptive false;
        _unit setDamage 0.5;
    };
};

_spawnedUnits pushBack _target;

// Spawn enemy search patrols near the target — scales with player count
// Base: 1 patrol for 1-2 players, +1 per 2 additional players
private _patrolCount = 1 + floor (_playerCount / 2);
_patrolCount = _patrolCount min 4;

private _enemyClasses = ["vn_o_men_nva_02", "vn_o_men_nva_03", "vn_o_men_nva_04", "vn_o_men_nva_05", "vn_o_men_nva_06", "vn_o_men_nva_07"];

for "_i" from 1 to _patrolCount do {
    private _patrolGrp = createGroup east;
    _patrolGrp deleteGroupWhenEmpty true;

    // 3-4 units per patrol, +1 for high player counts
    private _squadSize = 3 + (floor (_playerCount / 4));
    _squadSize = _squadSize min 6;

    private _patrolPos = _targetPos getPos [80 + random 120, random 360];
    for "_j" from 1 to _squadSize do {
        private _unit = _patrolGrp createUnit [selectRandom _enemyClasses, _patrolPos, [], 10, "NONE"];
        _spawnedUnits pushBack _unit;
    };

    // Patrol around the target area (searching)
    _patrolGrp setBehaviourStrong "AWARE";
    _patrolGrp setCombatMode "RED";
    private _wp1 = _patrolGrp addWaypoint [_targetPos getPos [50 + random 80, random 360], 0];
    _wp1 setWaypointType "MOVE";
    private _wp2 = _patrolGrp addWaypoint [_targetPos getPos [50 + random 80, random 360], 0];
    _wp2 setWaypointType "MOVE";
    private _wp3 = _patrolGrp addWaypoint [_targetPos getPos [50 + random 80, random 360], 0];
    _wp3 setWaypointType "CYCLE";
};

// Store references
[_blNetmap, "target", _target] call para_s_fnc_netmap_set;
[_blNetmap, "spawnedUnits", _spawnedUnits] call para_s_fnc_netmap_set;
[_blNetmap, "wreck", _wreck] call para_s_fnc_netmap_set;

// Create tasks (delayed)
[_mission, _missionId, _targetPos, _playerGroup, _rescueType, _blNetmap] spawn {
    params ["_mission", "_missionId", "_targetPos", "_playerGroup", "_rescueType", "_blNetmap"];
    sleep 10;

    private _approxPos = _targetPos getPos [150 + random 100, random 360];
    private _gridRef = (_approxPos call BIS_fnc_posToGrid) joinString " ";

    private _pilotVariant = _blNetmap getOrDefault ["pilotVariant", ""];
    private _callsign = "Covey 6";
    private _parentTaskId = format ["vgm_bright_light_%1", _missionId];

    [
        _playerGroup,
        _parentTaskId,
        [
            format [localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_TASK_DESCRIPTION", _callsign, _gridRef],
            format [localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_TASK_TITLE", _callsign]
        ],
        objNull,
        "ASSIGNED",
        -1,
        true,
        "search"
    ] call BIS_fnc_taskCreate;

    // Subtask 1: Locate (always present — points to crash for both variants)
    [
        _playerGroup,
        [format ["%1_locate", _parentTaskId], _parentTaskId],
        [
            format [localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_SUBTASK_LOCATE_DESC", _callsign, _gridRef],
            format [localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_SUBTASK_LOCATE_TITLE", _callsign]
        ],
        _approxPos,
        "ASSIGNED",
        -1,
        false,
        "search"
    ] call BIS_fnc_taskCreate;

    if (_pilotVariant == "pilot_captured") then {
        // Variant B subtasks: Gather Intel → Rescue → Extract
        [
            _playerGroup,
            [format ["%1_gatherIntel", _parentTaskId], _parentTaskId],
            [
                localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_SUBTASK_GATHERINTEL_DESC",
                localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_SUBTASK_GATHERINTEL_TITLE"
            ],
            objNull,
            "CREATED",
            -1,
            false,
            "search"
        ] call BIS_fnc_taskCreate;

        [
            _playerGroup,
            [format ["%1_followTrail", _parentTaskId], _parentTaskId],
            [
                localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_SUBTASK_FOLLOWTRAIL_DESC",
                localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_SUBTASK_FOLLOWTRAIL_TITLE"
            ],
            objNull,
            "CREATED",
            -1,
            false,
            "scout"
        ] call BIS_fnc_taskCreate;

        [
            _playerGroup,
            [format ["%1_rescue", _parentTaskId], _parentTaskId],
            [
                localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_SUBTASK_RESCUE_DESC",
                localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_SUBTASK_RESCUE_TITLE"
            ],
            objNull,
            "CREATED",
            -1,
            false,
            "heal"
        ] call BIS_fnc_taskCreate;
    } else {
        // Variant A: Secure subtask
        [
            _playerGroup,
            [format ["%1_secure", _parentTaskId], _parentTaskId],
            [
                localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_SUBTASK_SECURE_DESC",
                localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_SUBTASK_SECURE_TITLE"
            ],
            objNull,
            "CREATED",
            -1,
            false,
            "heal"
        ] call BIS_fnc_taskCreate;
    };

    // Subtask: Extract (always present)
    [
        _playerGroup,
        [format ["%1_extract", _parentTaskId], _parentTaskId],
        [
            localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_SUBTASK_EXTRACT_DESC",
            localize "STR_VGM_MISSIONS_BRIGHT_LIGHT_SUBTASK_EXTRACT_TITLE"
        ],
        objNull,
        "CREATED",
        -1,
        false,
        "getin"
    ] call BIS_fnc_taskCreate;

    ["vgm_voice_bright_light_briefing", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;

    // Trigger timer display on all mission group clients
    private _deadline = _blNetmap getOrDefault ["missionDeadline", 0];
    if (_deadline > 0) then {
        [_deadline, true] remoteExec ["vgm_c_fnc_missions_gameplay_bright_light_timerDisplay", _playerGroup];
    };

    // Voice lines tied to infil helicopter: approach + post-landing
    private _infilHeli = _playerGroup getVariable ["vgm_missions_infil_helicopter", objNull];
    private _crashPosLocal = _blNetmap getOrDefault ["crashPos", [0,0,0]];
    if (!isNull _infilHeli && {_crashPosLocal isNotEqualTo [0,0,0]}) then {
        [_missionId, _infilHeli, _crashPosLocal, _playerGroup] spawn {
            params ["_missionId", "_heli", "_crashPos", "_playerGroup"];

            // Wait until helicopter is ~1000m from crash, then play approach line
            waitUntil {sleep 1; !alive _heli || _heli distance2D _crashPos < 1000};
            if (alive _heli) then {
                ["vgm_voice_bright_light_approach", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;
            };

            // Wait until helicopter lands, then play moving out exchange
            waitUntil {sleep 1; !alive _heli || _heli getVariable ["vgm_missions_extractionLanded", false]};
            if (alive _heli) then {
                sleep 10;
                ["vgm_voice_bright_light_landed", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;
            };
        };
    };
};

// Start monitoring
[_missionId, _target, _playerGroup] spawn vgm_s_fnc_missions_gameplay_bright_light_monitorTarget;
