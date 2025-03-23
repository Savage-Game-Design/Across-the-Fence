/*
    File: fn_hideTerrainObjects.sqf
    Author: Savage Game Design
    Date: 2024-10-30
    Last Update: 2024-10-30
    Public: Yes

    Description:
        Hides terrain objects globally.

        Uses similar groups as the vanilla BI module, but omits rocks to avoid deleting cliff faces.

    Parameter(s):
        _position - Center of the area to hide [Pos2D]
        _radius - Radius of area [Number]
        _types - Array of categories [ARRAY]

    Returns:
        Object that can be used to un-hide terrain objects [HashMap]

    Example(s):
        [[0,0,0], 50, ["VEGETATION_SMALL", ROADS]] call vgm_s_fnc_hideTerrainObjects;
 */

#define TYPE_BUILDING ["BUILDING","HOUSE","CHURCH","CHAPEL","FUELSTATION","HOSPITAL","RUIN","BUNKER"]
#define TYPE_VEGETATION_LARGE ["TREE"]
#define TYPE_VEGETATION_SMALL ["SMALL TREE", "BUSH"]
#define TYPE_WALL ["WALL", "FENCE"]
#define TYPE_ROAD ["ROAD", "MAIN ROAD", "RAILWAY", "TRAIL"]
#define TYPE_ROCK ["ROCK","ROCKS"]
// !!IMPORTANT!! - When removing things from MISC, remember to add the new category to any sites which hide misc.
#define TYPE_MISC ["FOREST BORDER","FOREST TRIANGLE","FOREST SQUARE","CROSS","FORTRESS","FOUNTAIN","VIEW-TOWER","LIGHTHOUSE","QUAY","HIDE","BUSSTOP","FOREST","TRANSMITTER","STACK","TOURISM","WATERTOWER","TRACK","POWER LINES","POWERSOLAR","POWERWAVE","POWERWIND","SHIPWRECK"]

private _mapTypes = createHashMapFromArray [
    ["BUILDING", TYPE_BUILDING],
    ["VEGETATION_LARGE", TYPE_VEGETATION_LARGE],
    ["VEGETATION_SMALL", TYPE_VEGETATION_SMALL],
    ["VEGETATION", TYPE_VEGETATION_LARGE + TYPE_VEGETATION_SMALL],
    ["WALL", TYPE_WALL],
    ["ROADS", TYPE_ROAD],
    ["ROCKS", TYPE_ROCK],
    ["MISC", TYPE_MISC]
];

params ["_position", "_radius", "_types"];

{
    ["hideTerrainObjects: %1 isn't a valid category for hiding objects", _x] call vgm_g_fnc_logWarning;
} forEach (_types select {!(_x in _mapTypes)});

private _typesToHide = flatten (_types apply { _mapTypes getOrDefault [_x, []] });

private _objects = nearestTerrainObjects [_position, _typesToHide, _radius, false, true];

{
    _x hideObjectGlobal true;
} forEach _objects;

// Return a HashMap, as I think we might want to do a local version of this in the future.
// HashMap now allows us to easily add the necessary keys for local to work correctly later.
createHashMapFromArray [
    ["objects", _objects]
]
