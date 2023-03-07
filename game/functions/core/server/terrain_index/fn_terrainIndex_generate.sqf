/*
    File: fn_terrainIndex_generate.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-03-06
    Public: No

    Description:
        Generates an terrain index for the entire map. Store these later for future use with getArea, getGridSquareContents, etc.
        WARNING: This is a VERY heavy function. It will take a couple of minutes to complete.

    Parameter(s):
        0: worldSize [NUMBER] - The size of the world in meters.
        1: gridSquareSize [NUMBER] - The size of each grid square in meters.
        2: maxGradient [NUMBER] - The maximum gradient of the terrain in degrees.
        3: sizeOfArea [NUMBER] - The size of the area to check in meters.
        4: filteredObjects [ARRAY] - An array of objects to filter out of the terrain index.

    Returns:
        0: terrainIndex [ARRAY]

    Example(s):
        _artilleryIndex = [10000, 100, 10, 40, ["HOUSE", "FENCE"]] call vgm_s_fnc_terrainIndex_generate; // Generates a terrain index for a 10km x 10km map with a 10 degree average gradient and a 40m area to check.
        _artilleryIndex params ["_indexEntries", "_gridIndex"];
 */

params ["_worldSize", "_gridSquareSize", "_maxGradient", "_sizeOfArea", "_filteredObjects"];

// Array of things that can be found in the index.
// The entries for one grid row form a continuous block within the array, and each cell is also a continuous block.
// E.g, cell [1,1] might be a 100m x 100m cell, with the bottom left corner at [100, 100].
// All entries for cell [1,1] will be in a single block. such as between pos 30 and pos 47 in index_entries.
// All entries for row 3 will be in a single block, ordered by cell.
private _indexEntries = [];
// One entry per cell. The position in this array of each cell, can be found uniquely using the x and y coordinates (see get_grid_window, _rowRangeStart)
// Each entry contains the range in index_entries that has the cell contents. I.e, if the range is "[11, 32]", then items 11 through 32 of index_entries are in that cell.
private _gridIndex = [];

private _gridSize = _worldSize / _gridSquareSize;

// This performs setup, populating the index.
for "_y" from 0 to (_gridSize - 1) do {
    for "_x" from 0 to (_gridSize - 1) do {
        private _points = [];
        private _highestPoint = [_x * _gridSquareSize, _y * _gridSquareSize, 0];

        for "_i" from 0 to 20 do { // x-axis
            for "_j" from 0 to 20 do { // y-axis
                private _position = [_x * _gridSquareSize + (_i * 5), _y * _gridSquareSize + (_j * 5)];

                private _nearestTerrainObjects = [_position, _sizeOfArea, _filteredObjects] call vgm_g_fnc_area_getLocalObjects;
                if (count _nearestTerrainObjects > 0) then {
                    continue;
                };

                private _nearWater = [_position, _sizeOfArea] call vgm_g_fnc_area_isNearWater;
                if (surfaceIsWater _position || _nearWater) then {
                    continue;
                };

                private _positionGradient = abs (aCos ([0,0,1] vectorCos (surfaceNormal _position)));
                private _areaGradient = [_position, _sizeOfArea] call vgm_g_fnc_area_getGradient;
                if ((_areaGradient > _maxGradient || _positionGradient > _maxGradient) && _maxGradient != 0) then {
                    continue;
                };

                private _positionHeight = getTerrainHeightASL _position;
                if (_positionHeight > _highestPoint select 2) then {
                    _highestPoint = [_position select 0, _position select 1, _positionHeight];
                };

                _points pushBack _position;
            };
        };

        // Calculating the range in index_entries where the data can be found.
        private _start = count _indexEntries;
        private _end = _start + count _points - 1;
        if (count _points > 0) then {
            _indexEntries append _points;
            // Boolean true if the grid cell has entries, false otherwise
            _gridIndex pushBack [_start, _end, true, _highestPoint];
        } else {
            // Start is the index of the first entry in the *next* grid cell
            // End is the index of the last entry in the previous grid cell.
            // Makes the querying logic nice and simple, when we're fetching a range of grid cells.
            _gridIndex pushBack [_start, _end, false, _highestPoint];
        };
    };
};

[_indexEntries, _gridIndex]
