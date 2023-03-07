/*
    File: fn_terrainIndex_getArea.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-03-06
    Public: No

    Description:
        Returns the entries in the terrain index that are within the given area.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_corner1", "_corner2", "_gridSize", "_gridSquareSize", "_indexEntries", "_gridIndex"];

// Calculate the bottom left corner of the rectangle..
private _gridMinX = floor ((_corner1 # 0 min _corner2 # 0) / _gridSquareSize);
private _gridMinY = floor ((_corner1 # 1 min _corner2 # 1) / _gridSquareSize);
// Subtracting grid_size makes sure our results are always in-bounds.
// For example, without it, passing 500 would return everything between 500 and 600 when using a 100 grid size.
private _gridMaxX = floor (((_corner1 # 0 max _corner2 # 0) - _gridSize) / _gridSquareSize);
private _gridMaxY = floor (((_corner1 # 1 max _corner2 # 1) - _gridSize) / _gridSquareSize);

private _entries = [];

// The reason this is fast. We only need to iterate through the columns, we can fetch entire rows at once!
// We do that by grabbing entire rows at once
// - get the start of the range from the first cell in the row
// - get the end of the range from the last cell in the row.
// Works even if cells are empty, since empty cells store the start pos of the next populated cell, and end pos of the last populated cell.
for "_y" from _gridMinY to _gridMaxY do {
    private _rowRangeStart = _gridIndex # (_y * _gridSize + _gridMinX) # 0;
    private _rowRangeEnd = _gridIndex # (_y * _gridSize + _gridMaxX) # 1;
    // This works when RangeStart and RangeEnd are both in a cell with no entries.
    // This is because _rowRangeEnd - _rowRangeStart will be `-1`, so we end up selecting 0 entries!
    _entries pushBack (_indexEntries select [_rowRangeStart, (_rowRangeEnd - _rowRangeStart) + 1])
};

// Flattening once is MASSIVELY faster than concatenating a bunch of arrays in SQF, and way way way faster than using append.
flatten _entries
