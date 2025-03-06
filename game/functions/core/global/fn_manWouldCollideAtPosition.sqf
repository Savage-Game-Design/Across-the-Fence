/*
    File: fn_manWouldCollideAtPosition.sqf
    Author:
    Date: 2025-03-06
    Last Update: 2025-03-06
    Public: No

    Description:
        A basic heuristic check to see if a given position can fit a man.

        Intended to be used with pathfinding / waypoint setting, to check if a location is inside an object
        e.g Rocks or a cliff face.

    Parameter(s):
        _positionATL - Position to check [PosATL]

    Returns:
        True if a unit would collide with an object at that position [BOOLEAN]

    Example(s):
        [getPosATL player] call vgm_g_fnc_manWouldCollideAtPosition;
 */

params ["_positionATL"];

// Converts 2D to 3D, and moves the start point above the terrain.
private _startPos = _positionATL vectorAdd [0, 0, 0.2];
private _endPos = _positionATL vectorAdd [0, 0, 1.8];

lineIntersectsSurfaces [ATLtoASL _startPos, ATLtoASL _endPos, objNull, objNull, true, 1, "GEOM", "NONE"] isNotEqualTo []
