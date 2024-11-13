/*
    File: fn_area_getLocalObjects.sqf
    Author: Savage Game Design
    Date: 2023-03-03
    Last Update: 2023-03-21
    Public: Yes

    Description:
        Returns an array of all objects within a given area.

    Parameter(s):
        _pos - Central position to find average gradient at [ARRAY]
        _radius - Radius to search within [NUMBER]
        _types - Types of objects to search for [ARRAY]

    Returns:
        Array of objects [ARRAY]

    Example(s):
        [position player, 20, ["WALL", "FENCE"]] call vgm_g_area_getLocalObjects;
 */

params ["_position", "_radius", "_types"];

nearestTerrainObjects [_position, _types, _radius, false, false] // result
