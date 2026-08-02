/*
    File: fn_amblife_spawnCivilians.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Spawns civilian villager groups near buildings. Each group gets 3-4
        cyclic MOVE waypoints at nearby building positions so they walk around.
        Civilians are setCaptive true so OPFOR ignores them.

    Parameter(s):
        _missionId         - Mission ID [NUMBER]
        _buildingPositions - Array of building positions [ARRAY]
        _count             - Number of civilian groups to spawn [NUMBER]

    Returns:
        Nothing

    Example(s):
        [0, _buildings, 4] call vgm_s_fnc_amblife_spawnCivilians;
 */

params ["_missionId", "_buildingPositions", "_count"];

if (_count <= 0 || count _buildingPositions < 2) exitWith {};

// Pick spread-out building positions for group origins
private _usedPositions = [];

for "_i" from 1 to _count do {
    // Find a building position at least 100m from already-used ones
    private _candidates = _buildingPositions select {
        private _pos = _x;
        _usedPositions findIf {_x distance2D _pos < 100} == -1
    };

    if (count _candidates == 0) then {
        _candidates = _buildingPositions;
    };

    private _originPos = selectRandom _candidates;
    _usedPositions pushBack _originPos;

    private _groupSize = 1 + floor random 3; // 1-3

    private _squad = createHashMapFromArray [
        ["pos", _originPos],
        ["composition", vgm_s_amblife_civilianClasses],
        ["sizeRange", [_groupSize, _groupSize]],
        ["side", civilian],
        ["missionId", _missionId],
        ["deleteOnDespawn", true],
        ["groupVars", createHashMap],
        ["onSpawn", {
            params ["_squad"];
            private _group = _squad get "group";
            private _origin = _squad get "pos";

            // Set group behavior
            _group setBehaviourStrong "SAFE";
            _group setSpeedMode "LIMITED";
            _group setCombatMode "BLUE";

            // setCaptive on all units so OPFOR ignores them
            {
                _x setCaptive true;
            } forEach units _group;

            // Find nearby building positions for waypoints (~50m radius)
            private _nearBuildings = nearestObjects [_origin, ["House"], 80];
            private _wpPositions = _nearBuildings apply {getPos _x};
            if (count _wpPositions < 3) then {
                // Fallback: generate random positions around origin
                for "_j" from 1 to 4 do {
                    _wpPositions pushBack (_origin getPos [20 + random 40, random 360]);
                };
            };

            // Shuffle and pick 3-4 waypoints
            _wpPositions = _wpPositions call BIS_fnc_arrayShuffle;
            private _wpCount = (3 + floor random 2) min (count _wpPositions);

            for "_j" from 0 to (_wpCount - 1) do {
                private _wp = _group addWaypoint [_wpPositions # _j, 3];
                _wp setWaypointType "MOVE";
                _wp setWaypointSpeed "LIMITED";
                _wp setWaypointBehaviour "SAFE";
                _wp setWaypointCompletionRadius 5;
            };

            // Cycle back to first waypoint
            private _wpCycle = _group addWaypoint [_wpPositions # 0, 3];
            _wpCycle setWaypointType "CYCLE";
        }]
    ];

    [_squad] call vgm_s_fnc_virtsquad_create;
};
