/*
    File: fn_terrainIndex_generate.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-03-22
    Public: No

    Description:
        Generates an terrain index for the entire map. Store these later for future use with getArea, getGridSquareContents, etc.
        WARNING: This is a VERY heavy function. It will take a couple of minutes to complete.

    Parameter(s):
        1: _gridSquareSize [NUMBER] - The size of each grid square in meters.
        2: _maxGradient [NUMBER] - The maximum gradient of the terrain in degrees.
        3: _sizeOfArea [NUMBER] - The size of the area to check in meters.
        4: _filteredObjects [ARRAY] - An array of objects to filter out of the terrain index.
        5: _pointGenerator [CODE] - A function that generates points to check. It should take two parameters, _points and _x, _y.
            _points is an array of points to check.
            _x and _y are the x and y coordinates of the grid square to check.

    Returns:
        0: terrainIndex [ARRAY]

    Example(s):
        _artilleryIndex = [10000, 100, 10, 40, ["HOUSE", "FENCE"]] call vgm_s_fnc_terrainIndex_generate; // Generates a terrain index for a 10km x 10km map with a 10 degree average gradient and a 40m area to check.
        _artilleryIndex params ["_indexEntries", "_gridIndex"];
 */

params ["_pointGenerator"];

// Array of things that can be found in the index.
// The entries for one grid row form a continuous block within the array, and each cell is also a continuous block.
// E.g, cell [1,1] might be a 100m x 100m cell, with the bottom left corner at [100, 100].
// All entries for cell [1,1] will be in a single block. such as between pos 30 and pos 47 in index_entries.
// All entries for row 3 will be in a single block, ordered by cell.
private _indexEntries = [];
// One entry per cell. The position in this array of each cell, can be found uniquely using the x and y coordinates (see get_grid_window, _rowRangeStart)
// Each entry contains the range in index_entries that has the cell contents. I.e, if the range is "[11, 32]", then items 11 through 32 of index_entries are in that cell.
private _gridIndex = [];

private _gridSize = worldSize / 100;

// This performs setup, populating the index.
for "_y" from 0 to (_gridSize - 1) do {
    for "_x" from 0 to (_gridSize - 1) do {
        private _points = [_x, _y] call _pointGenerator;

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

[_indexEntries, _gridIndex]
