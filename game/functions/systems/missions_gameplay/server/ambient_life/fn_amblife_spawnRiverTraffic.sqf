/*
    File: fn_amblife_spawnRiverTraffic.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Spawns civilian sampan boats on water. Alternates between patrol boats
        (cyclic waypoints) and stationary fishermen.
        Skips entirely if no water positions found.

    Parameter(s):
        _missionId      - Mission ID [NUMBER]
        _waterPositions - Array of water positions [ARRAY]
        _count          - Number of river boats to spawn [NUMBER]

    Returns:
        Nothing

    Example(s):
        [0, _waterPos, 2] call vgm_s_fnc_amblife_spawnRiverTraffic;
 */

params ["_missionId", "_waterPositions", "_count"];

if (_count <= 0 || count _waterPositions < 2) exitWith {};

for "_i" from 1 to _count do {
    private _spawnPos = selectRandom _waterPositions;
    private _isPatrol = (_i mod 2) == 1; // Alternate: patrol, stationary, patrol...

    private _squad = createHashMapFromArray [
        ["pos", _spawnPos],
        ["composition", vgm_s_amblife_civilianClasses],
        ["sizeRange", [1, 1]],
        ["side", civilian],
        ["missionId", _missionId],
        ["deleteOnDespawn", true],
        ["groupVars", createHashMap],
        ["onSpawn", compile format [
            '
            params ["_squad"];
            private _group = _squad get "group";
            private _leader = leader _group;
            private _pos = getPos _leader;

            _leader setCaptive true;

            // Verify spawn position is still on water
            if !(surfaceIsWater _pos) exitWith {
                diag_log format ["[AmbLife] Boat spawn position not on water at %%1 - skipping", _pos];
            };

            // Create sampan
            private _boatClass = selectRandom vgm_s_amblife_civBoatClasses;
            private _boat = createVehicle [_boatClass, _pos, [], 0, "NONE"];
            _leader moveInDriver _boat;

            _squad set ["amblife_vehicle", _boat];

            _group setBehaviourStrong "SAFE";
            _group setSpeedMode "LIMITED";
            _group setCombatMode "BLUE";

            if (%1) then {
                // Patrol boat: cycle between water positions
                private _waterPos = %2;
                private _wpPositions = (_waterPos call BIS_fnc_arrayShuffle) select [0, 3 min count _waterPos];
                {
                    private _wp = _group addWaypoint [_x, 20];
                    _wp setWaypointType "MOVE";
                    _wp setWaypointSpeed "LIMITED";
                    _wp setWaypointCompletionRadius 30;
                } forEach _wpPositions;
                if (count _wpPositions > 0) then {
                    private _wpCycle = _group addWaypoint [_wpPositions # 0, 20];
                    _wpCycle setWaypointType "CYCLE";
                };
            };
            ',
            _isPatrol,
            _waterPositions
        ]]
    ];

    [_squad] call vgm_s_fnc_virtsquad_create;
};
