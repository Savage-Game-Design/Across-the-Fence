/*
    File: fn_terrainIndex_getGridSquareContents.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-03-06
    Public: No

    Description:
        Returns the contents of a grid square.

    Parameter(s):
        0: _position [ARRAY] - Position to fetch contents for
        1: _gridSize [NUMBER] - Size of the grid, calculated by dividing the world size by the grid square size;
        2: _terrainIndex [ARRAY] - Terrain index to fetch from

    Returns:
        Array of positions [ARRAY]

    Example(s):
        [[1200,1200], 100, _artilleryIndex] call vgm_s_fnc_terrainIndex_getGridSquareContents;
 */

params ["_position", "_gridSize", "_terrainIndex"];
_terrainIndex params ["_indexEntries", "_gridIndex"];

// Figure out which cell this position is in.
private _x = floor (_position # 0 / 100);
private _y = floor (_position # 1 / 100);

// Fetch the data range for this cell
private _range = _gridIndex select (_y * _gridSize + _x);
_range params ["_start", "_end", "_hasContents", "_highestPoint"];

// No contents of the cell, nothing to fetch
if (!_hasContents) exitWith {[]};

// Returns the entries
_indexEntries select [_start, (_end - _start) + 1]
