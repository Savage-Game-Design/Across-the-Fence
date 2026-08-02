/*
    File: fn_amblife_respawnMonitor.sqf
    Author: AtlasActual
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Periodically checks if road vehicles have been despawned (left player range)
        and spawns replacements near random players after a cooldown.
        Runs as a spawned loop per mission, stopped when mission ends.
        Uses amblife_type tags for accurate counting.
        Trucks respawn as convoys (multi-vehicle virtsquads).
        Bicycle convoys respawn as multi-bike virtsquads.
        Counts total vehicles (via amblife_convoySize) against budget for convoys.

    Parameter(s):
        _missionId        - Mission ID [NUMBER]
        _opforTruckBudget - Target total number of OPFOR trucks [NUMBER]
        _civBudget        - Target number of civilian vehicles [NUMBER]
        _bikeConvoyBudget - Target number of bicycle convoys [NUMBER]

    Returns:
        Nothing (runs as spawned loop)

    Example(s):
        [0, 3, 0, 2] spawn vgm_s_fnc_amblife_respawnMonitor;
 */

params ["_missionId", "_opforTruckBudget", "_civBudget", ["_bikeConvoyBudget", 0]];

// Wait initial delay before first check
sleep vgm_s_amblife_respawnInitialDelay;

while {vgm_s_amblife_missionActive getOrDefault [_missionId, false]} do {

    // Get all squads for this mission
    private _missionInfo = [_missionId] call vgm_s_fnc_virtsquad_getMissionSquadsInfo;
    if (isNil "_missionInfo") exitWith {};

    private _allSquads = values (_missionInfo get "squads");

    // Count active road vehicles by amblife_type tag
    // For convoys, count total vehicles (not squads) using amblife_convoySize
    private _activeOpforTrucks = 0;
    private _activeCivVehicles = 0;
    private _activeBikeConvoys = 0;
    {
        if !(_x getOrDefault ["deleted", false]) then {
            private _type = _x getOrDefault ["amblife_type", ""];
            if (_type == "opforTruck") then {
                _activeOpforTrucks = _activeOpforTrucks + (_x getOrDefault ["amblife_convoySize", 1]);
            };
            if (_type == "civVehicle") then {
                _activeCivVehicles = _activeCivVehicles + 1;
            };
            if (_type == "bicycleConvoy") then {
                _activeBikeConvoys = _activeBikeConvoys + 1;
            };
        };
    } forEach _allSquads;

    // --- Respawn OPFOR truck convoys ---
    private _neededTrucks = _opforTruckBudget - _activeOpforTrucks;
    while {_neededTrucks > 0} do {
        private _spawnPos = [] call vgm_s_fnc_amblife_findRoadNearPlayer;
        if (_spawnPos isEqualTo []) exitWith {};

        // Determine convoy size
        private _min = vgm_s_amblife_truckConvoySizeRange # 0;
        private _max = vgm_s_amblife_truckConvoySizeRange # 1;
        private _convoySize = (_min + floor random ((_max - _min) + 1)) min _neededTrucks;

        private _composition = [];
        for "_i" from 1 to _convoySize do {
            _composition pushBack (selectRandom vgm_s_amblife_opforDriverClasses);
        };

        private _template = [
            _composition,
            _spawnPos,
            _missionId
        ] call vgm_s_fnc_director_getEnemySquadTemplate;

        _template deleteAt "btreeName";
        _template set ["deleteOnDespawn", true];
        _template set ["sizeRange", [_convoySize, _convoySize]];
        _template set ["amblife_type", "opforTruck"];
        _template set ["amblife_convoySize", _convoySize];
        _template set ["onSpawn", {
            params ["_squad"];
            private _group = _squad get "group";
            private _units = units _group;
            private _pos = getPos (leader _group);
            private _vehicles = [];

            // Find road direction at spawn point
            private _spawnRoad = roadAt _pos;
            private _roadDir = 0;
            if (!isNull _spawnRoad) then {
                private _connected = roadsConnectedTo _spawnRoad;
                if (count _connected > 0) then {
                    _roadDir = _spawnRoad getDir (_connected # 0);
                };
            };

            {
                private _truckClass = selectRandom vgm_s_amblife_opforTruckClasses;
                private _offset = _pos getPos [_forEachIndex * 20, _roadDir + 180];
                private _snapRoad = roadAt _offset;
                if (isNull _snapRoad) then {
                    private _nearRoads = _offset nearRoads 30;
                    if (count _nearRoads > 0) then {_snapRoad = _nearRoads # 0};
                };
                private _spawnPos = if (!isNull _snapRoad) then {getPos _snapRoad} else {_offset};
                private _truck = createVehicle [_truckClass, _spawnPos, [], 0, "NONE"];
                _truck setDir _roadDir;
                _x moveInDriver _truck;
                _truck forceFollowRoad true;
                _truck limitSpeed 40;
                _truck addEventHandler ["Killed", {
                    params ["_vehicle", "_killer", "_instigator"];
                    private _player = if (!isNull _instigator) then {_instigator} else {_killer};
                    if (isNull _player || {!isPlayer _player}) exitWith {};
                    [_player, 50] call vgm_s_fnc_leveling_addExperience;
                    {hint parseText "<t size='1.1' color='#FFD700'>+50 XP</t><br/><t size='0.85'>Supply truck destroyed</t>"} remoteExec ["call", _player];
                }];
                _vehicles pushBack _truck;
            } forEach _units;

            _squad set ["amblife_vehicles", _vehicles];

            _group setFormation "COLUMN";
            _group setBehaviourStrong "SAFE";
            _group setCombatMode "YELLOW";
            _group setSpeedMode "LIMITED";

            private _destPos = [_pos, 800, 1200] call vgm_s_fnc_amblife_walkRoadNetwork;
            if !(_destPos isEqualTo []) then {
                private _wp = _group addWaypoint [_destPos, 10];
                _wp setWaypointType "MOVE";
                _wp setWaypointSpeed "LIMITED";
                _wp setWaypointCompletionRadius 30;

                private _wpCycle = _group addWaypoint [_pos, 10];
                _wpCycle setWaypointType "CYCLE";
            };

            diag_log format ["[AmbLife] Respawned truck convoy (%1 trucks)", count _vehicles];
        }];

        [_template] call vgm_s_fnc_virtsquad_create;
        _neededTrucks = _neededTrucks - _convoySize;
    };

    // --- Respawn civilian vehicles ---
    private _neededCivs = _civBudget - _activeCivVehicles;
    for "_i" from 1 to _neededCivs do {
        private _spawnPos = [] call vgm_s_fnc_amblife_findRoadNearPlayer;
        if !(_spawnPos isEqualTo []) then {
            private _squad = createHashMapFromArray [
                ["pos", _spawnPos],
                ["composition", vgm_s_amblife_civilianClasses],
                ["sizeRange", [1, 1]],
                ["side", civilian],
                ["missionId", _missionId],
                ["deleteOnDespawn", true],
                ["amblife_type", "civVehicle"],
                ["groupVars", createHashMap],
                ["onSpawn", {
                    params ["_squad"];
                    private _group = _squad get "group";
                    private _leader = leader _group;
                    private _pos = getPos _leader;

                    _leader setCaptive true;

                    private _vehClass = selectRandom vgm_s_amblife_civVehicleClasses;
                    private _safePos = _pos findEmptyPosition [0, 25, _vehClass];
                    if (_safePos isEqualTo []) then {
                        _safePos = _pos findEmptyPosition [5, 50, _vehClass];
                    };
                    if (_safePos isEqualTo []) exitWith {
                        diag_log format ["[AmbLife] Respawn: No safe position for civ vehicle at %1", _pos];
                    };
                    private _vehicle = createVehicle [_vehClass, _safePos, [], 0, "NONE"];
                    _leader moveInDriver _vehicle;
                    _squad set ["amblife_vehicle", _vehicle];

                    _group setBehaviourStrong "SAFE";
                    _group setSpeedMode "LIMITED";
                    _group setCombatMode "BLUE";

                    _vehicle forceFollowRoad true;
                    _vehicle limitSpeed 30;

                    private _destPos = [_pos, 600, 1000] call vgm_s_fnc_amblife_walkRoadNetwork;
                    if !(_destPos isEqualTo []) then {
                        private _wp = _group addWaypoint [_destPos, 10];
                        _wp setWaypointType "MOVE";
                        _wp setWaypointSpeed "LIMITED";
                        _wp setWaypointCompletionRadius 30;
                    };
                }]
            ];

            [_squad] call vgm_s_fnc_virtsquad_create;
            diag_log format ["[AmbLife] Respawned civilian vehicle for mission %1", _missionId];
        };
    };

    // --- Respawn bicycle convoys ---
    private _neededBikeConvoys = _bikeConvoyBudget - _activeBikeConvoys;
    for "_i" from 1 to _neededBikeConvoys do {
        private _spawnPos = [] call vgm_s_fnc_amblife_findRoadNearPlayer;
        if !(_spawnPos isEqualTo []) then {
            private _min = vgm_s_amblife_bikeConvoySizeRange # 0;
            private _max = vgm_s_amblife_bikeConvoySizeRange # 1;
            private _convoySize = _min + floor random ((_max - _min) + 1);

            private _composition = [];
            for "_j" from 1 to _convoySize do {
                _composition pushBack (selectRandom vgm_s_amblife_bikeMuleClasses);
            };

            private _template = [
                _composition,
                _spawnPos,
                _missionId
            ] call vgm_s_fnc_director_getEnemySquadTemplate;

            _template deleteAt "btreeName";
            _template set ["deleteOnDespawn", true];
            _template set ["sizeRange", [_convoySize, _convoySize]];
            _template set ["amblife_type", "bicycleConvoy"];
            _template set ["amblife_convoySize", _convoySize];
            _template set ["onSpawn", {
                params ["_squad"];
                private _group = _squad get "group";
                private _units = units _group;
                private _pos = getPos (leader _group);
                private _vehicles = [];

                {
                    private _offset = _pos getPos [_forEachIndex * 8, 180];
                    private _safePos = _offset findEmptyPosition [0, 15, "vn_o_bicycle_02"];
                    if (_safePos isEqualTo []) then {
                        _safePos = _offset findEmptyPosition [3, 30, "vn_o_bicycle_02"];
                    };
                    if (_safePos isEqualTo []) then {
                        diag_log format ["[AmbLife] Respawn: No safe position for convoy bike %1 at %2", _forEachIndex, _offset];
                    } else {
                        private _bike = createVehicle ["vn_o_bicycle_02", _safePos, [], 0, "NONE"];
                        _x moveInDriver _bike;
                        _bike forceFollowRoad true;
                        _bike addEventHandler ["Killed", {
                            params ["_vehicle", "_killer", "_instigator"];
                            private _player = if (!isNull _instigator) then {_instigator} else {_killer};
                            if (isNull _player || {!isPlayer _player}) exitWith {};
                            [_player, 25] call vgm_s_fnc_leveling_addExperience;
                            {hint parseText "<t size='1.1' color='#FFD700'>+25 XP</t><br/><t size='0.85'>Supply bike destroyed</t>"} remoteExec ["call", _player];
                        }];
                        vgm_s_amblife_activeBikes pushBack _bike;
                        _vehicles pushBack _bike;
                    };
                } forEach _units;

                _squad set ["amblife_vehicles", _vehicles];

                _group setFormation "COLUMN";
                _group setBehaviourStrong "SAFE";
                _group setCombatMode "YELLOW";
                _group setSpeedMode "LIMITED";

                private _destPos = [_pos, 600, 1000] call vgm_s_fnc_amblife_walkRoadNetwork;
                if !(_destPos isEqualTo []) then {
                    private _wp = _group addWaypoint [_destPos, 10];
                    _wp setWaypointType "MOVE";
                    _wp setWaypointSpeed "LIMITED";
                    _wp setWaypointCompletionRadius 20;

                    private _wpCycle = _group addWaypoint [_pos, 10];
                    _wpCycle setWaypointType "CYCLE";
                };

                diag_log format ["[AmbLife] Respawned bicycle convoy (%1 bikes)", count _vehicles];
            }];

            [_template] call vgm_s_fnc_virtsquad_create;
        };
    };

    // Wait cooldown before next check
    sleep vgm_s_amblife_respawnCooldown;
};
