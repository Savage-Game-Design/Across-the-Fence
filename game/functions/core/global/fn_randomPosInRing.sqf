/*
    File: fn_randomPosInRing.sqf
    Author: Savage Game Design
    Date: 2024-10-25
    Last Update: 2024-10-25
    Public: No

    Description:
        Generates random position inside a ring.
        https://sqf.ovh/sqf%20math/2018/05/05/generate-a-random-position.html

    Parameter(s):
        _center - Ring center [OBJECT, ARRAY]
        _radius - Ring radius [NUMBER]
        _innerRadius - Inner ring radius [NUMBER]

    Returns:
        Position [ARRAY]

    Example(s):
        [getPosATL player] call vgm_g_fnc_randomPosInRing
 */

params [
    ["_center", nil, [objNull, []]],
    ["_radius", 0, [0]],
    ["_innerRadius", 0, [0]]
];

_center getPos [sqrt (_innerRadius^2 + random (_radius^2 - _innerRadius^2)), random 360] // return
