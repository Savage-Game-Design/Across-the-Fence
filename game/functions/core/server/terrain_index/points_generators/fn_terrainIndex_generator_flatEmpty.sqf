/*
    File: fn_terrainIndex_generator_flatEmpty.sqf
    Author:
    Date: 2023-06-30
    Last Update: 2023-07-02
    Public: Yes

    Description:
        Generates an array of points in the given area.
        Only points with enough empty space and on flat enough terrain will be included.

    Parameter(s):
        _x - X coordinate of the bottom left of the area [NUMBER]
        _y - Y coordinate of the bottom left of the area [NUMBER]
        _size - Size of the square area to generator for [NUMBER]
        _params - Parameters accepted by the generator. See code. [HashMap]


    Returns:
        Points that match the given criteria [Array]

    Example(s):
        [1000, 1200, 100, createHashMap] call vgm_s_fnc_terrainIndex_generator_isFlatEmpty;
 */

params ["_x", "_y", "_size", ["_params", createHashMap]];

// Parameters
private _searchGridCellSize = _params getOrDefault ["searchGridCellSize", 5];
private _minimumSpace = _params getOrDefault ["minimumSpace", 4];
private _maxGradient = _params getOrDefault ["maxGradient", 0.3];
private _gradientArea = _params getOrDefault ["gradientArea", 5];


// Basic and reliable. Tends to find good empty spaces, in most parts of the map.
private _findEmptyPositionStrategy = {
	params ["_pos2D"];
    private _freeAreaSearchDistance = 2;
    _pos2D findEmptyPosition [_minimumSpace, _freeAreaSearchDistance];

};

// Raycast strategy finds nearby terrain objects, and tries to intersect lines with them to see
// how close they are.

// This is a fallback strategy for when findEmptyPosition fails in areas of the map.
// This is most notable in the jungle - lots of thick canopy means findEmptyPosition returns
// nothing for big chunks of the map (500m x 500m areas, for example).

// Raycast is less safe, much slower, but can find spaces where findEmptyPosition fails.
private _raycastStrategy = {
	params ["_pos2D"];

    private _posASL = AGLtoASL (_pos2D + [0.3]);
    private _terrainSearchDistance = 15;
    // Can't filter to specific terrain objects - there's relevant objects that don't show up when filtered (e.g wooden guard tower)
	private _objects = nearestTerrainObjects [ASLtoAGL _posASL, [], _terrainSearchDistance, false, true];
	private _intersectionPositions = [];
	{
		_intersectionPositions append (
			lineIntersectsSurfaces [_posASL, getPosASL _x, objNull, objNull, true, 1, "PHYSX", "GEOM"]
            // Filter out world intersections - they tend to happen in perfectly fine locations
            select {!isNull (_x # 3)}
            // Get intersection location in ASL
            apply {_x # 0}
		);
	} forEach _objects;

    private _wouldCollide = (_intersectionPositions findIf {_x distance2D _posASL < _minimumSpace} > -1);
    [_pos2D, []] select (_wouldCollide)
};

private _performGridSearchWithStrategy = {
    params ["_strategy"];

    private _gridSizeInCells = _size / _searchGridCellSize;
    private _results = [];

    for "_xOffset" from 0 to (_gridSizeInCells - 1) do {
        for "_yOffset" from 0 to (_gridSizeInCells - 1) do {
            private _pos2D = [_x + (_xOffset * _searchGridCellSize), _y + _yOffset * _searchGridCellSize];

            private _emptyPos = [_pos2D] call _strategy;

            if (
                _emptyPos isEqualTo [] ||
                { _emptyPos isFlatEmpty [-1, -1, _maxGradient, _gradientArea] isEqualTo [] }
            ) then { continue; };

            _results pushBack _emptyPos;
        };
    };

    _results
};

private _basicResults = [_findEmptyPositionStrategy] call _performGridSearchWithStrategy;

if (count _basicResults > 0) exitWith {
    _basicResults;
};

// Slower and less safe, only use raycast if we haven't found any results.
[_raycastStrategy] call _performGridSearchWithStrategy
