/*
    File: fn_terrainIndex_getGridSquareContents.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-03-23
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
private _gridSize = _terrainIndex get "grid_size";
private _gridSizeSquare = _terrainIndex get "grid_size_square";

// Figure out which cell this position is in.
private _x = floor (_position # 0 / _gridSizeSquare);
private _y = floor (_position # 1 / _gridSizeSquare);

// Fetch the data range for this cell
private _range = _gridIndex select (_y * _gridSize + _x);
_range params ["_start", "_end", "_hasContents", "_highestPoint"];

// No contents of the cell, nothing to fetch
if (!_hasContents) exitWith {[]};

// Returns the entries
_indexEntries select [_start, (_end - _start) + 1]
