/*
    File: fn_terrainIndex_getGridSquareContents.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-06-30
    Public: No

    Description:
        Returns the contents of a grid square.

    Parameter(s):
        _position [ARRAY] - Position to fetch contents for
        _terrainIndex [HASHMAP] - Terrain index to fetch from

    Returns:
        Array of positions [ARRAY]

    Example(s):
        [[1200,1200], _artilleryIndex] call vgm_s_fnc_terrainIndex_getGridSquareContents;
 */

params ["_position", "_terrainIndex"];

private _indexEntries = _terrainIndex get "index_entries";
private _gridIndex = _terrainIndex get "grid_index";
private _gridSizeInSquares = _terrainIndex get "grid_size_in_squares";
private _gridSizeSquare = _terrainIndex get "grid_size_square";
private _gridOrigin = _terrainIndex get "grid_origin";

private _relativeX = (_position # 0) - (_gridOrigin # 0);
private _relativeY = (_position # 1) - (_gridOrigin # 1);

// Figure out which cell this position is in.
private _xIndex = floor (_relativeX / _gridSizeSquare);
private _yIndex = floor (_relativeY / _gridSizeSquare);

// Fetch the data range for this cell
private _range = _gridIndex select (_yIndex * _gridSizeInSquares + _xIndex);
_range params ["_start", "_end", "_hasContents", "_highestPoint"];

// No contents of the cell, nothing to fetch
if (!_hasContents) exitWith {[]};

// Returns the entries
_indexEntries select [_start, (_end - _start) + 1]
