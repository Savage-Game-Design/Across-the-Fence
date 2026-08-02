/*
    File: fn_skill_prairieFire_shootdown.sqf
    Author: Atlas
    Date: 2026-03-05
    Last Update: 2026-03-05
    Public: No

    Description:
        Server-side handler for CAS aircraft shootdown events. When CAS is called
        via the Prairie Fire RTO skill, this script rolls a chance (5% at 0 alertness,
        10% at max) that NVA AAA shoots down the aircraft. If triggered, it creates
        a dynamic rescue side objective with a 20-minute deadline.

        The shootdown is forced via script (not AI targeting). A DShKM is spawned
        temporarily for visual tracers, and damage is applied directly.

        Only one shootdown can be active per mission at a time.

    Parameter(s):
        _aircraft           - The CAS aircraft [OBJECT]
        _group              - The aircraft's group [GROUP]
        _caller             - Player who called CAS [OBJECT]
        _missionId          - Mission ID [NUMBER]
        _duration           - CAS loiter duration in seconds [NUMBER]
        _hadArtilleryTrait  - Whether caller had vn_artillery before CAS [BOOLEAN]

    Returns:
        Nothing

    Example(s):
        [_aircraft, _group, _caller, _missionId, _duration, false] spawn vgm_s_fnc_skill_prairieFire_shootdown
*/

params ["_aircraft", "_group", "_caller", "_missionId", "_duration", ["_hadArtilleryTrait", false]];

if (!isServer) exitWith {};

// Guard: only one shootdown per mission at a time
private _director = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;
if (isNil "_director") exitWith {};

if (_director getOrDefault ["vgm_s_shootdownActive", false]) exitWith {
    "Prairie Fire Shootdown: Already active for this mission, skipping" call vgm_g_fnc_logInfo;
};

// Get alertness and calculate probability
private _alertness = _director getOrDefault ["alertness", 0];
private _shootdownChance = linearConversion [0, 100, _alertness, 0.05, 0.10, true];

// Roll dice
if (random 1 > _shootdownChance) exitWith {
    format ["Prairie Fire Shootdown: No shootdown (chance was %1%2, alertness %3)", round (_shootdownChance * 100), "%", round _alertness] call vgm_g_fnc_logInfo;
};

// Mark shootdown active
_director set ["vgm_s_shootdownActive", true];
_aircraft setVariable ["vgm_s_prairieFire_shotDown", true, true];

format ["Prairie Fire Shootdown: Aircraft will be shot down (chance was %1%2, alertness %3)", round (_shootdownChance * 100), "%", round _alertness] call vgm_g_fnc_logInfo;

// Schedule shootdown at random time during loiter (30-120 seconds in)
private _shootdownDelay = 30 + random 90;
// Cap to not exceed duration minus some margin
_shootdownDelay = _shootdownDelay min (_duration - 15);
if (_shootdownDelay < 10) then {_shootdownDelay = 10};

sleep _shootdownDelay;

// Verify aircraft still alive
if (isNull _aircraft || !alive _aircraft) exitWith {
    _director set ["vgm_s_shootdownActive", false];
    "Prairie Fire Shootdown: Aircraft already destroyed before shootdown, aborting" call vgm_g_fnc_logInfo;
};

// --- SHOOTDOWN SEQUENCE ---
private _aircraftPos = getPosATL _aircraft;

// Spawn temporary DShKM at 800-1200m from aircraft
private _aaDir = random 360;
private _aaDist = 800 + random 400;
private _aaPos = _aircraftPos getPos [_aaDist, _aaDir];
_aaPos set [2, 0];

private _aaGroup = createGroup east;
_aaGroup deleteGroupWhenEmpty true;
private _aaGun = createVehicle ["vn_o_static_dshkm_01", _aaPos, [], 0, "NONE"];
private _aaGunner = _aaGroup createUnit ["vn_o_men_nva_02", _aaPos, [], 0, "NONE"];
_aaGunner moveInGunner _aaGun;
_aaGun setDir (_aaPos getDir _aircraftPos);

// Force the DShKM to target and fire at aircraft
_aaGroup setCombatMode "RED";
_aaGroup setBehaviourStrong "COMBAT";
_aaGunner doWatch _aircraft;
_aaGunner doTarget _aircraft;
_aaGunner commandTarget _aircraft;
_aaGun doWatch _aircraft;

// Short delay for visual tracers
sleep 1;

// Force fire (backup in case AI doesn't fire)
if (alive _aaGunner) then {
    _aaGunner forceWeaponFire [currentWeapon _aaGun, "FullAuto"];
};

// Play voice line: aircraft going down
["cas", "cas_shootdown", true, objNull, true] call vgm_s_fnc_voicelines_play;

// Apply damage via script regardless of hit
sleep 1;
if (!isNull _aircraft && alive _aircraft) then {
    _aircraft setHitPointDamage ["HitEngine", 0.9];
    _aircraft setHitPointDamage ["HitHRotor", 1.0];
};

// Remove artillery trait if caller didn't have it before CAS
if (!_hadArtilleryTrait && alive _caller) then {
    _caller setUnitTrait ["vn_artillery", false];
};

// Mark aircraft as no longer active for CAS targeting
_aircraft setVariable ["vgm_s_skill_prairieFire_active", false, true];

// Continue firing for visual effect
sleep 2;

// Delete AAA static
if (!isNull _aaGun) then {
    if (!isNull _aaGunner) then {deleteVehicle _aaGunner};
    deleteVehicle _aaGun;
};

// --- MONITOR AIRCRAFT DESCENT ---
// Wait for aircraft to hit ground or 30s timeout
private _crashTimeout = serverTime + 30;
waitUntil {
    sleep 0.5;
    isNull _aircraft ||
    !alive _aircraft ||
    (getPosATL _aircraft select 2) < 3 ||
    serverTime > _crashTimeout
};

// Record crash position
private _crashPos = if (!isNull _aircraft) then {
    getPosATL _aircraft
} else {
    _aircraftPos
};
_crashPos set [2, 0];

// Delete aircraft + crew
if (!isNull _aircraft) then {
    {deleteVehicle _x} forEach crew _aircraft;
    deleteVehicle _aircraft;
};

// --- CREATE CRASH SCENE ---
// Map aircraft class to matching wreck class and crew count
private _aircraftClass = typeOf _aircraft;
private _wreckMap = createHashMapFromArray [
    ["vn_b_air_ah1g_04",    ["vn_air_ah1g_01_wreck", 2]],
    ["vn_b_air_ah1g_05",    ["vn_air_ah1g_01_wreck", 2]],
    ["vn_b_air_ah1g_06",    ["vn_air_ah1g_01_wreck", 2]],
    ["vn_b_air_uh1c_01_01", ["vn_air_uh1c_01_wreck", 2]],
    ["vn_b_air_uh1c_02_01", ["vn_air_uh1c_01_wreck", 2]],
    ["vn_b_air_uh1c_03_01", ["vn_air_uh1c_01_wreck", 2]],
    ["vn_b_air_oh6a_03",    ["vn_air_oh6a_01_wreck", 1]]
];
private _wreckData = _wreckMap getOrDefault [_aircraftClass, ["", 2]];
private _wreckClass = _wreckData # 0;

// Only proceed if aircraft has a known wreck variant
if (_wreckClass == "") exitWith {
    _director set ["vgm_s_shootdownActive", false];
    format ["Prairie Fire Shootdown: No wreck class for %1, aborting crash scene", _aircraftClass] call vgm_g_fnc_logInfo;
};

private _crewCount = _wreckData # 1;
private _crashDir = random 360;
private _sceneResult = [_crashPos, _crashDir, _wreckClass, "vn_b_men_aircrew_01", _crewCount] call vgm_s_fnc_bright_light_createCrashScene;
private _sceneObjects = _sceneResult get "sceneObjects";
private _hiddenTerrainObjects = _sceneResult get "hiddenTerrainObjects";
private _wreck = _sceneResult get "wreck";

// --- DETERMINE VARIANT ---
// Check if any scouting sites exist within 300-600m of crash for Variant B
private _mission = [_missionId] call vgm_s_fnc_missions_getById;
private _playerGroup = group _caller;
private _sitePos = [0,0,0];
private _pilotVariant = "pilot_at_crash";

if (!isNil "_mission") then {
    private _targetZone = (_mission get "public") get "targetZone";
    if (!isNil "_targetZone") then {
        private _sites = +(_targetZone call vgm_s_fnc_missions_zones_getSites);
        // Filter sites within 300-600m of crash
        private _nearbySites = _sites select {
            private _d = (_x get "pos") distance2D _crashPos;
            _d >= 300 && _d <= 600
        };
        if (_nearbySites isNotEqualTo []) then {
            // 50/50 chance of Variant B
            if (random 1 < 0.5) then {
                _pilotVariant = "pilot_captured";
                // Pick closest site
                private _closestDist = 1e10;
                {
                    private _d = (_x get "pos") distance2D _crashPos;
                    if (_d < _closestDist) then {
                        _closestDist = _d;
                        _sitePos = _x get "pos";
                    };
                } forEach _nearbySites;
            };
        };
    };
};

// --- SPAWN PILOT + VARIANT-SPECIFIC CONTENT ---
private _spawnedUnits = [];
private _pilotGrp = createGroup west;
_pilotGrp deleteGroupWhenEmpty true;
private _pilot = objNull;
private _enemyClasses = ["vn_o_men_nva_02", "vn_o_men_nva_03", "vn_o_men_nva_04", "vn_o_men_nva_05", "vn_o_men_nva_06", "vn_o_men_nva_07"];

if (_pilotVariant == "pilot_at_crash") then {
    // Variant A: pilot unconscious near wreck
    private _pilotPos = _crashPos getPos [5 + random 5, random 360];
    _pilot = _pilotGrp createUnit ["vn_b_men_aircrew_01", _pilotPos, [], 0, "NONE"];
    format ["Prairie Fire Shootdown: Variant A — pilot at crash %1", _crashPos] call vgm_g_fnc_logInfo;
} else {
    // Variant B: pilot captured — held at nearby site
    private _pilotPos = _sitePos getPos [5 + random 10, random 360];
    _pilot = _pilotGrp createUnit ["vn_b_men_aircrew_01", _pilotPos, [], 0, "NONE"];
    removeHeadgear _pilot;

    // NVA investigators at crash (2-3 soldiers)
    private _invGrp = createGroup east;
    _invGrp deleteGroupWhenEmpty true;
    private _invCount = 2 + floor random 2;
    for "_i" from 1 to _invCount do {
        private _invPos = _crashPos getPos [5 + random 10, random 360];
        private _unit = _invGrp createUnit [selectRandom _enemyClasses, _invPos, [], 0, "NONE"];
        _spawnedUnits pushBack _unit;
    };
    _invGrp setBehaviourStrong "AWARE";
    _invGrp setCombatMode "RED";

    // NVA guards at site (3-4 soldiers)
    private _guardGrp = createGroup east;
    _guardGrp deleteGroupWhenEmpty true;
    private _guardCount = 3 + floor random 2;
    for "_i" from 1 to _guardCount do {
        private _guardPos = _sitePos getPos [10 + random 20, random 360];
        private _unit = _guardGrp createUnit [selectRandom _enemyClasses, _guardPos, [], 0, "NONE"];
        _spawnedUnits pushBack _unit;
    };
    _guardGrp setBehaviourStrong "AWARE";
    _guardGrp setCombatMode "RED";
    private _wp = _guardGrp addWaypoint [_sitePos, 15];
    _wp setWaypointType "GUARD";

    // Intel object at crash — pilot helmet
    private _helmetPos = _crashPos getPos [10 + random 5, random 360];
    _helmetPos set [2, 0];
    private _intelObj = createVehicle ["GroundWeaponHolder", [0,0,0], [], 0, "CAN_COLLIDE"];
    _intelObj setPosATL _helmetPos;
    _intelObj addItemCargoGlobal ["vn_b_helmet_sph4", 1];
    _sceneObjects pushBack _intelObj;

    // Blood trail from crash to capture site
    private _trailDist = _crashPos distance2D _sitePos;
    private _trailDir = _crashPos getDir _sitePos;
    private _traveled = 5 + random 5;
    while {_traveled < _trailDist - 10} do {
        private _bloodPos = _crashPos getPos [_traveled, _trailDir + (-5 + random 10)];
        _bloodPos set [2, 0];
        private _bloodObj = createVehicle ["BloodSplat_01_Large_New_F", _bloodPos, [], 0, "CAN_COLLIDE"];
        _bloodObj setDir random 360;
        _bloodObj setVectorUp surfaceNormal _bloodPos;
        _sceneObjects pushBack _bloodObj;
        [_bloodObj, [_sitePos]] remoteExec ["vgm_c_fnc_sites_hints_initObject", 0, true];
        _traveled = _traveled + 5 + random 10;
    };

    // Hold action on intel object
    _intelObj setVariable ["vgm_cas_shootdown_intelObj", true, true];
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
            _target setVariable ["vgm_cas_shootdown_intelGathered", true, true];
            hint "Pilot's helmet — blood trail leads away from the crash.";
        },
        {},
        nil,
        8,
        100,
        true,
        false
    ] remoteExec ["BIS_fnc_holdActionAdd", 0, _intelObj];

    format ["Prairie Fire Shootdown: Variant B — pilot captured at site %1, crash at %2", _sitePos, _crashPos] call vgm_g_fnc_logInfo;
};

_pilot setCaptive true;
_pilot setUnconscious true;
_pilot setVariable ["vgm_bright_light_target", true, true];
_pilot setVariable ["vgm_cas_shootdown_pilot", true, true];

// SOG Advanced Revive integration — allows players to bandage the pilot back up
private _hdEH = _pilot addEventHandler ["HandleDamage", {_this call vn_fnc_revive_handledamage}];
_pilot setVariable ["vn_revive_event_handledamage", _hdEH];
_pilot addEventHandler ["HandleDamage", {
    params ["_unit"];
    if (_unit getVariable ["vn_revive_incapacitated", false] && {!isPlayer _unit}) then {
        _unit setUnconscious true;
        _unit setCaptive true;
    };
}];

// Mark as incapacitated for SOG revive UI (bandage / pick up / load)
_pilot setVariable ["vn_revive_incapacitated", true, true];
[_pilot] call vn_fnc_revive_actions_local;

// Monitor for SOG revive clearing incapacitated — restore AI state when revived
[_pilot] spawn {
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

// --- REGISTER BRIGHT LIGHT NETMAP (side mission XP tracking) ---
private _deadline = serverTime + 1200;
private _blNetmap = [_missionId, "bright_light"] call vgm_s_fnc_missions_createSystemNetmap;
[_blNetmap, "rescueType", "downed_pilot"] call para_s_fnc_netmap_set;
[_blNetmap, "targetFound", false] call para_s_fnc_netmap_set;
[_blNetmap, "targetRescued", false] call para_s_fnc_netmap_set;
[_blNetmap, "targetExtracted", false] call para_s_fnc_netmap_set;
[_blNetmap, "target", _pilot] call para_s_fnc_netmap_set;
[_blNetmap, "pilotVariant", _pilotVariant] call para_s_fnc_netmap_set;
[_blNetmap, "crashPos", _crashPos] call para_s_fnc_netmap_set;
[_blNetmap, "sitePos", _sitePos] call para_s_fnc_netmap_set;
[_blNetmap, "spawnedUnits", _spawnedUnits] call para_s_fnc_netmap_set;
[_blNetmap, "wreck", _wreck] call para_s_fnc_netmap_set;
[_blNetmap, "sceneObjects", _sceneObjects] call para_s_fnc_netmap_set;
[_blNetmap, "hiddenTerrainObjects", _hiddenTerrainObjects] call para_s_fnc_netmap_set;
[_blNetmap, "missionDeadline", _deadline] call para_s_fnc_netmap_set;
[_blNetmap, "intelGathered", false] call para_s_fnc_netmap_set;

// --- CREATE MARKER ---
private _approxPos = _crashPos getPos [100 + random 100, random 360];
private _markerName = format ["vgm_cas_shootdown_%1", serverTime];
private _marker = createMarker [_markerName, _approxPos];
_marker setMarkerType "mil_warning";
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Downed Aircraft";
_marker setMarkerAlpha 0.8;

// --- CREATE TASK ---
private _taskId = format ["vgm_cas_shootdown_%1", floor serverTime];
private _gridRef = (_approxPos call BIS_fnc_posToGrid) joinString " ";

private _taskDesc = if (_pilotVariant == "pilot_captured") then {
    format ["CAS aircraft shot down by NVA AAA near grid %1. The pilot may have been captured. Search the crash site for intel. You have 20 minutes.", _gridRef]
} else {
    format ["CAS aircraft shot down by NVA AAA near grid %1. Locate the crash site and rescue the downed pilot. You have 20 minutes before NVA forces overrun the area.", _gridRef]
};

[
    true,
    [_taskId],
    [_taskDesc, "Rescue Downed Pilot", ""],
    _approxPos,
    "ASSIGNED",
    -1,
    true,
    "search"
] call BIS_fnc_taskCreate;

// --- RAISE ALERTNESS ---
[_director, 25] call vgm_s_fnc_director_addAlertness;

format ["Prairie Fire Shootdown: Crash scene created at %1, pilot variant %2, task %3", _crashPos, _pilotVariant, _taskId] call vgm_g_fnc_logInfo;

// --- MONITORING LOOP ---
private _nvaSpawned = false;
private _pilotRescued = false;
private _lastBleedTime = serverTime;
private _bleedInterval = 120;
private _taskComplete = false;
// Variant B tracking
private _intelProcessed = false;
private _trailFollowed = false;
private _crashFound = false;
// Variant A tracking
private _assaultTriggered = false;
private _assaultCountdown = -1;

while {!_taskComplete} do {
    sleep 2;

    // Check pilot alive
    if (!alive _pilot) exitWith {
        [_taskId, "FAILED"] call BIS_fnc_taskSetState;
        _taskComplete = true;
        format ["Prairie Fire Shootdown: Pilot KIA, task failed"] call vgm_g_fnc_logInfo;
    };

    // Bleed-out: pilot takes damage if not carried
    private _carriedBy = _pilot getVariable ["vgm_carry_carriedBy", objNull];
    if (isNull _carriedBy && {serverTime - _lastBleedTime > _bleedInterval}) then {
        private _currentDamage = damage _pilot;
        _pilot setDamage (_currentDamage + 0.15);
        _lastBleedTime = serverTime;
        format ["Prairie Fire Shootdown: Pilot bleed tick, damage now %1", damage _pilot] call vgm_g_fnc_logInfo;
    };

    // 20-minute deadline check
    if (serverTime > _deadline) exitWith {
        [vgm_s_voicelines_coveyUnit, "vn_radiocom_coop_03_11"] remoteExec ["sideRadio", 0];
        sleep 10;
        [_taskId, "FAILED"] call BIS_fnc_taskSetState;
        _taskComplete = true;
        format ["Prairie Fire Shootdown: Deadline expired, task failed"] call vgm_g_fnc_logInfo;
    };

    if (_pilotVariant == "pilot_at_crash") then {
        // --- VARIANT A: Assault on approach ---
        // targetFound when players within 25m of pilot with no enemies within 25m
        if (!_crashFound) then {
            private _nearPlayers = allPlayers select {alive _x && _x distance _pilot < 25};
            private _nearEnemies = (getPosATL _pilot) nearEntities ["Man", 25] select {alive _x && side group _x == east};
            if (_nearPlayers isNotEqualTo [] && {_nearEnemies isEqualTo []}) then {
                _crashFound = true;
                [_blNetmap, "targetFound", true] call para_s_fnc_netmap_set;
                ["vgm_voice_bright_light_crashSecure", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;
                format ["Prairie Fire Shootdown: Target found (Variant A)"] call vgm_g_fnc_logInfo;
            };
        };

        // Assault trigger: players within 100m starts countdown
        if (!_assaultTriggered) then {
            private _nearPlayers = allPlayers select {alive _x && _x distance2D _crashPos < 100};
            if (_nearPlayers isNotEqualTo [] && _assaultCountdown < 0) then {
                _assaultCountdown = serverTime + 30 + random 30;
                format ["Prairie Fire Shootdown: Assault countdown started"] call vgm_g_fnc_logInfo;
            };

            if (_assaultCountdown > 0 && serverTime >= _assaultCountdown) then {
                _assaultTriggered = true;

                private _avgPos = [0,0,0];
                private _alivePlayers = allPlayers select {alive _x && _x distance2D _crashPos < 300};
                {_avgPos = _avgPos vectorAdd (getPosATL _x)} forEach _alivePlayers;
                _avgPos = _avgPos vectorMultiply (1 / (count _alivePlayers max 1));

                private _bearingToPlayers = _crashPos getDir _avgPos;
                private _assaultBearing = (_bearingToPlayers + 180) mod 360;

                private _squadCount = 2 + floor random 2;
                for "_i" from 1 to _squadCount do {
                    private _squadBearing = _assaultBearing + (-30 + random 60);
                    private _spawnPos = _crashPos getPos [150 + random 100, _squadBearing];
                    private _nvaGrp = createGroup east;
                    _nvaGrp deleteGroupWhenEmpty true;
                    private _squadSize = 4 + floor random 3;
                    for "_j" from 1 to _squadSize do {
                        private _unit = _nvaGrp createUnit [selectRandom _enemyClasses, _spawnPos, [], 10, "NONE"];
                        _spawnedUnits pushBack _unit;
                    };
                    _nvaGrp setBehaviourStrong "AWARE";
                    _nvaGrp setCombatMode "RED";
                    private _wp = _nvaGrp addWaypoint [_crashPos, 30];
                    _wp setWaypointType "SAD";
                };

                [_blNetmap, "spawnedUnits", _spawnedUnits] call para_s_fnc_netmap_set;
                format ["Prairie Fire Shootdown: NVA assault spawned (%1 squads)", _squadCount] call vgm_g_fnc_logInfo;
            };
        };
    } else {
        // --- VARIANT B: Intel + trail + rescue ---
        // Crash site found: players within 40m of crash, no enemies within 40m
        if (!_crashFound) then {
            private _nearCrash = allPlayers select {alive _x && _x distance2D _crashPos < 40};
            private _nearEnemies = _crashPos nearEntities ["Man", 40] select {alive _x && side group _x == east};
            if (_nearCrash isNotEqualTo [] && {_nearEnemies isEqualTo []}) then {
                _crashFound = true;
                [_blNetmap, "targetFound", true] call para_s_fnc_netmap_set;
                ["vgm_voice_bright_light_crashSecure", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;
                format ["Prairie Fire Shootdown: Crash site found (Variant B)"] call vgm_g_fnc_logInfo;
            };
        };

        // Intel gathered (hold action sets variable on intel object)
        if (!_intelProcessed) then {
            private _intelObjs = _sceneObjects select {_x getVariable ["vgm_cas_shootdown_intelGathered", false]};
            if (_intelObjs isNotEqualTo []) then {
                _intelProcessed = true;
                [_blNetmap, "intelGathered", true] call para_s_fnc_netmap_set;
                format ["Prairie Fire Shootdown: Intel gathered, follow trail"] call vgm_g_fnc_logInfo;
            };
        };

        // Trail followed: players within 50m of capture site
        if (_intelProcessed && !_trailFollowed && {_sitePos isNotEqualTo [0,0,0]}) then {
            private _nearSite = allPlayers select {alive _x && _x distance2D _sitePos < 50};
            if (_nearSite isNotEqualTo []) then {
                _trailFollowed = true;
                format ["Prairie Fire Shootdown: Trail followed, pilot location reached"] call vgm_g_fnc_logInfo;
            };
        };
    };

    // Check if pilot is rescued (being carried by a player)
    if (!_pilotRescued && {!isNull _carriedBy}) then {
        _pilotRescued = true;
        [_blNetmap, "targetRescued", true] call para_s_fnc_netmap_set;
        ["vgm_voice_bright_light_targetPickedUp", [_missionId], [2, _playerGroup]] call para_g_fnc_event_triggerTargets;
        format ["Prairie Fire Shootdown: Pilot picked up by %1", name _carriedBy] call vgm_g_fnc_logInfo;
    };

    // Check if pilot is in a vehicle (extraction)
    if (_pilotRescued) then {
        private _inVehicle = vehicle _pilot != _pilot;
        if (_inVehicle) then {
            [_blNetmap, "targetExtracted", true] call para_s_fnc_netmap_set;
            [_taskId, "SUCCEEDED"] call BIS_fnc_taskSetState;
            _taskComplete = true;
            format ["Prairie Fire Shootdown: Pilot extracted, task succeeded"] call vgm_g_fnc_logInfo;
        } else {
            // Also check if pilot is near players AND no enemies within 100m (safe rescue)
            private _nearFriendly = allPlayers select {alive _x && _x distance _pilot < 30};
            private _nearEnemies = (getPosATL _pilot) nearEntities ["Man", 100] select {alive _x && side group _x == east};
            if (_nearFriendly isNotEqualTo [] && {_nearEnemies isEqualTo []}) then {
                [_blNetmap, "targetExtracted", true] call para_s_fnc_netmap_set;
                [_taskId, "SUCCEEDED"] call BIS_fnc_taskSetState;
                _taskComplete = true;
                format ["Prairie Fire Shootdown: Pilot secured (area clear), task succeeded"] call vgm_g_fnc_logInfo;
            };
        };
    };
};

// --- CLEANUP ---
// Delete marker
deleteMarker _markerName;

// Delete scene after 60 seconds
sleep 60;

// Unhide terrain objects
{_x hideObjectGlobal false} forEach _hiddenTerrainObjects;

// Delete scene objects
{
    if (!isNull _x) then {deleteVehicle _x};
} forEach _sceneObjects;

// Delete spawned NVA units
{
    if (!isNull _x && alive _x) then {deleteVehicle _x};
} forEach _spawnedUnits;

// Delete pilot if still alive (task ended)
if (!isNull _pilot && alive _pilot) then {
    deleteVehicle _pilot;
};

// Delete wreck
if (!isNull _wreck) then {deleteVehicle _wreck};

// Remove task after delay
sleep 30;
[_taskId, true, true] call BIS_fnc_deleteTask;

// Clear shootdown flag
_director set ["vgm_s_shootdownActive", false];

format ["Prairie Fire Shootdown: Cleanup complete"] call vgm_g_fnc_logInfo;
