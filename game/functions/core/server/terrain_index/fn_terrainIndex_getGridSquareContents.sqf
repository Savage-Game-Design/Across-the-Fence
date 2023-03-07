/*
    File: fn_terrainIndex_getGridSquareContents.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-03-06
    Public: No

    Description:
        Returns the contents of a grid square.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_position", "_gridSize", "_indexEntries", "_gridIndex"];

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
