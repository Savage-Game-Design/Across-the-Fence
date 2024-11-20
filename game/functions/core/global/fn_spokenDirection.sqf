/*
    File: fn_spokenDirection.sqf
    Author: Savage Game Design
    Date: 2024-10-31
    Last Update: 2024-11-01
    Public: Yes

    Description:
        Get direction of an object, or direction "from-to" objects/positions as "spoken" variant.

    Parameter(s):
        _origin - Object or starting position [OBJECT, ARRAY]
        _towards - Object or position to trace direction from origin [OBJECT, ARRAY]

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_g_fnc_spokenDirection
 */

params [
    ["_origin", [0,0,0], [[], objNull], [2,3]],
    ["_towards", [], [[], objNull], [2,3]]
];

// get bearing from-to position or object direction
private _bearing = if (_towards isEqualTo []) then {getDir _origin} else {_origin getDir _towards};

private _directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"];
_directions select round (_bearing / 45) % 8 // return
