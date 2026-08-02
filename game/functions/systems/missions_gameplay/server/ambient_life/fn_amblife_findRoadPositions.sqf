/*
    File: fn_amblife_findRoadPositions.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Finds road segments and intersections within the target box.
        Intersections are roads with 3+ connections, deduplicated within 50m.

    Parameter(s):
        _boxCenter   - Center of the target box [ARRAY]
        _boxApothems - [halfWidth, halfHeight] of the target box [ARRAY]

    Returns:
        [roadSegments, intersections] - Arrays of road objects and intersection positions [ARRAY]

    Example(s):
        [_center, _apothems] call vgm_s_fnc_amblife_findRoadPositions;
 */

params ["_boxCenter", "_boxApothems"];

private _searchRadius = (_boxApothems # 0) max (_boxApothems # 1);
private _roads = _boxCenter nearRoads _searchRadius;

// Filter roads to those actually within the box bounds
private _minX = (_boxCenter # 0) - (_boxApothems # 0);
private _maxX = (_boxCenter # 0) + (_boxApothems # 0);
private _minY = (_boxCenter # 1) - (_boxApothems # 1);
private _maxY = (_boxCenter # 1) + (_boxApothems # 1);

private _filteredRoads = _roads select {
    private _pos = getPos _x;
    (_pos # 0) >= _minX && (_pos # 0) <= _maxX &&
    (_pos # 1) >= _minY && (_pos # 1) <= _maxY
};

// Find intersections (roads with 3+ connections)
private _intersections = [];
{
    private _connected = roadsConnectedTo _x;
    if (count _connected >= 3) then {
        private _pos = getPos _x;
        // Deduplicate within 50m
        private _tooClose = _intersections findIf {_x distance2D _pos < 50};
        if (_tooClose == -1) then {
            _intersections pushBack _pos;
        };
    };
} forEach _filteredRoads;

[_filteredRoads, _intersections]
