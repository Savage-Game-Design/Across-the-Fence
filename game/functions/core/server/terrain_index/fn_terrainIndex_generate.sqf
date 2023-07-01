/*
    File: fn_terrainIndex_generate.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-07-01
    Public: No

    Description:
        Generates an terrain index for the entire map. Store these later for future use with getArea, getGridSquareContents, etc.
        The result will be copied to your clipboard as a string, which you can paste into indices.hpp

        WARNING: This is a VERY heavy function. The time it takes to generate the index is directly proportional to the size of the map and the quality of the index.

    Parameter(s):
        _pointGenerator [CODE] - A function that generates points to check. It should take two parameters, _points and _x, _y.
            _points is an array of points to check.
            _x and _y are the x and y coordinates of the grid square to check.
        _gridOrigin - Where the generation should start, bottom left coordinate of the square [ARRAY]
        _gridSize - How big of a square area should be indexed [NUMBER]
        _gridSquareSize [NUMBER] - The size of each grid square, in meters.
        _generatorParams [ANY] - Parameters to pass to the generator
        _maxPointsPerGridSquare [NUMBER] - Maximum number of points for each grid square. 0 or less means no limit.
            Calculated probabilistically, so may not be exact.

    Returns:
        _terrainIndex [HASHMAP] - A hashmap containing the terrain index data and metadata.

    Example(s):
        _artilleryIndex = [{
            params ["_x", "_y", "_gridSquareSize", "_params"];

            _searchGridCellSize = _params getOrDefault ["searchGridCellSize", 5];

            private _return = [];
            private _itrCount = _gridSquareSize / _searchGridCellSize;

            for "_i" from 0 to _itrCount do { // x-axis
                for "_j" from 0 to _itrCount do { // y-axis
                    private _position = [_x * _gridSquareSize + (_i * _searchGridCellSize), _y * _gridSquareSize + (_j * _searchGridCellSize)];

                    private _nearWater = [_position, 5] call vgm_g_fnc_area_isNearWater;
                    if (!surfaceIsWater _position && _nearWater) then {
                        _return pushBack _position;
                    };
                };
            };

            _return
        }, 100, 5] call vgm_s_fnc_terrainIndex_generate;
 */

params [
    "_pointGenerator",
    ["_gridOrigin", [0, 0]],
    ["_gridSize", worldSize],
    ["_gridSquareSize", 100],
    ["_generatorParams", createHashMap],
    ["_maxPointsPerGridSquare", -1]
];

// Array of things that can be found in the index.
// The entries for one grid row form a continuous block within the array, and each cell is also a continuous block.
// E.g, cell [1,1] might be a 100m x 100m cell, with the bottom left corner at [100, 100].
// All entries for cell [1,1] will be in a single block. such as between pos 30 and pos 47 in index_entries.
// All entries for row 3 will be in a single block, ordered by cell.
private _indexEntries = [];
// One entry per cell. The position in this array of each cell, can be found uniquely using the x and y coordinates (see get_grid_window, _rowRangeStart)
// Each entry contains the range in index_entries that has the cell contents. I.e, if the range is "[11, 32]", then items 11 through 32 of index_entries are in that cell.
private _gridIndex = [];

private _gridSizeInSquares = floor (_gridSize / _gridSquareSize);

// This performs setup, populating the index.
for "_y" from 0 to (_gridSizeInSquares - 1) do {
    for "_x" from 0 to (_gridSizeInSquares - 1) do {
        private _currentX = (_gridOrigin # 0) + (_x * _gridSquareSize);
        private _currentY = (_gridOrigin # 1) + (_y * _gridSquareSize);
        private _points = [_currentX, _currentY, _gridSquareSize, _generatorParams] call _pointGenerator;

        // Reduce the number of points down to the maximum.
        if (_maxPointsPerGridSquare > 0 && count _points > _maxPointsPerGridSquare) then {
            // Limit the number of points removed, as we don't want to accidentally remove too many if there's only a couple to begin with.
            private _pointsLeftToRemove = count _points - _maxPointsPerGridSquare;
            private _retentionProbability = _maxPointsPerGridSquare / (count _points max 1);

            _points = _points select {
                (
                    _pointsLeftToRemove <= 0 ||
                    random 1 < _retentionProbability
                ) || {
                    _pointsLeftToRemove = _pointsLeftToRemove - 1;
                    false
                }
            };
        };

        // Calculating the range in index_entries where the data can be found.
        private _start = count _indexEntries;
        private _end = _start + count _points - 1;
        if (count _points > 0) then {
            _indexEntries append _points;

            // Boolean true if the grid cell has entries, false otherwise
            _gridIndex pushBack [_start, _end, true];
        } else {
            // Start is the index of the first entry in the *next* grid cell
            // End is the index of the last entry in the previous grid cell.
            // Makes the querying logic nice and simple, when we're fetching a range of grid cells.
            _gridIndex pushBack [_start, _end, false];
        };
    };
};

private _result = createHashMapFromArray [
    ["index_entries", _indexEntries],
    ["grid_index", _gridIndex],
    ["grid_size_in_squares", _gridSizeInSquares],
    ["grid_square_size", _gridSquareSize],
    ["grid_origin", _gridOrigin]
];

private _clipboard = str _result;
_clipboard = _clipboard regexReplace ["\[", "{"];
_clipboard = _clipboard regexReplace ["\]", "}"];
_clipboard = _clipboard + ";";

copyToClipboard _clipboard;

_result
