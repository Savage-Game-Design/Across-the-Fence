/*
    File: fn_terrainIndex_addPoint.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2024-05-25
    Public: No

    Description:
        Adds a point to a specific index.

    Parameter(s):
        _index - Index we're modifying [HASHMAP]
        _pos - Position the point is at [POSITION]
        _value - Value to add to the index [ANY]

    Returns:
        Nothing

    Example(s):
        [myIndex, [99, 99, 99], "Returns this when queried"] call vgm_s_fnc_terrainIndex_addPoint;
 */

params ["_terrainIndex", "_pos", "_value"];

private _gridIndex = _terrainIndex get "grid_index";
private _cellIndices = _terrainIndex get "cell_indices";
private _indexEntries = _terrainIndex get "index_entries";

private _gridSizeInSquares = _terrainIndex get "grid_size_in_squares";
private _gridSquareSize = _terrainIndex get "grid_square_size";
private _gridOrigin = _terrainIndex get "grid_origin";

private _gridX = floor (((_pos # 0) - (_gridOrigin # 0)) / _gridSquareSize);
private _gridY = floor (((_pos # 1) - (_gridOrigin # 1)) / _gridSquareSize);

// Point is out of bounds, abort
if (_gridX < 0 || _gridX >= _gridSizeInSquares || _gridY < 0 || _gridY >= _gridSizeInSquares) exitWith {};

private _gridIndexIndex = _gridY * _gridSizeInSquares + _gridX;

(_gridIndex # _gridIndexIndex) params ["_cellIndicesIndex", "_cellPoints"];

_cellPoints pushBack _value;

// Cell was previously empty, need to add it to the index data.
// Can check by seeing if the cell indexes is an array, which would be purged by `flatten` when fetching.
if (_cellIndices # _cellIndicesIndex isEqualType []) then {
    _cellIndices set [_cellIndicesIndex, _indexEntries pushBack _cellPoints];
};
