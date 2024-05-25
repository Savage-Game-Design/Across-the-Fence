/*
    File: fn_terrainIndex_getArea.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2024-05-25
    Public: No

    Description:
        Returns the entries in the terrain index that are within the given area.

    Parameter(s):
        _origin - Bottom left corner of the area to search [POSITION]
        _width - Width of the area to search [NUMBER]
        _height - Height of the area to search [NUMBER]
        _terrainIndex - The terrain index to use. [ARRAY]
        _flatten - Return a flat array of numbers. [BOOLEAN]

    Returns:
        _entries - The entries in the terrain index that are within the given area. [ARRAY]

    Example(s):
        [[1000,1000], [1200,1200], artilleryIndex] call vgm_s_fnc_terrainIndex_getArea;
 */

params ["_origin", "_width", "_height", "_terrainIndex", ["_flatten", false]];

private _gridIndex = _terrainIndex get "grid_index";
private _cellIndices = _terrainIndex get "cell_indices";
private _indexEntries = _terrainIndex get "index_entries";
private _gridSizeInSquares = _terrainIndex get "grid_size_in_squares";
private _gridSquareSize = _terrainIndex get "grid_square_size";
private _gridOrigin = _terrainIndex get "grid_origin";

// Calculate the bottom left corner of the rectangle, relative to the start of the index.
private _minX = (_origin # 0) - _gridOrigin # 0;
private _minY = (_origin # 1) - _gridOrigin # 1;

private _gridMinXIndex = floor (_minX / _gridSquareSize) max 0;
private _gridMinYIndex = floor (_minY / _gridSquareSize) max 0;
// Subtracting gridSquareSize makes sure our results are always in-bounds.
// For example, without it, passing 500 would return everything between 500 and 600 when using a 100 grid size.
private _maxX = ((_origin # 0 + _width) - _gridSquareSize) - _gridOrigin # 0;
private _maxY = ((_origin # 1 + _height) - _gridSquareSize) - _gridOrigin # 1;

private _gridMaxXIndex = floor (_maxX / _gridSquareSize) min (_gridSizeInSquares - 1);
private _gridMaxYIndex = floor (_maxY / _gridSquareSize) min (_gridSizeInSquares - 1);

private _cellIndexes = [];

// The reason this is fast. We only need to iterate through the columns, we can fetch entire rows at once!
// We do that by grabbing entire rows at once
// - get the start of the range from the first cell in the row
// - get the end of the range from the last cell in the row.
// Works even if cells are empty, since empty cells store the start pos of the next populated cell, and end pos of the last populated cell.

for "_y" from _gridMinYIndex to _gridMaxYIndex do {
    private _rowOffset = _y * _gridSizeInSquares;
    private _rowRangeStart = _gridIndex # (_rowOffset + _gridMinXIndex) # 0;
    private _rowRangeEnd = _gridIndex # (_rowOffset + _gridMaxXIndex) # 0;
    // This works when RangeStart and RangeEnd are both in a cell with no entries.
    // This is because _rowRangeEnd - _rowRangeStart will be `-1`, so we end up selecting 0 entries!
    _cellIndexes pushBack (_cellIndices select [_rowRangeStart, (_rowRangeEnd - _rowRangeStart) + 1])
};

_cellIndexes = flatten _cellIndexes;

private _entries = _cellIndexes apply {_indexEntries # _x};


if (_flatten) exitWith {
    // Flattening once is MASSIVELY faster than concatenating a bunch of arrays in SQF, and way way way faster than using append.
    // Downside is it becomes a flat array of numbers, rather than an array of positions, so the output needs to be used carefully.
    flatten _entries
};

_entries
