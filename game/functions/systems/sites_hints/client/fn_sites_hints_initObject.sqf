/*
    File: fn_sites_hints_initObject.sqf
    Author: Savage Game Design
    Date: 2024-10-27
    Last Update: 2024-11-02
    Public: No

    Description:
        Initialize hint object.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [allSitesObjects # 0, [[0, 0, 0]]] call vgm_c_fnc_sites_hints_initObject
 */

params ["_object", "_args"];
_args params ["_sitePos"];

vgm_sites_hints_objectsList pushBack _object;

_object addAction [
    "Inspect",
    {
        params ["_object", "", "", "_args"];
        _args params ["_sitePos"];

        hint format [
            "Near the object you see tracks leading towards %1",
            [_object, _sitePos] call vgm_g_fnc_spokenDirection
        ];
    },
    [_sitePos],
    100,
    true,
    true,
    "",
    toString {true},
    2
];

private _fnc_modifierDefault = {_this setVectorUp surfaceNormal getPosATL _this};
_object call (vgm_sites_hints_placementModifiers getOrDefault [typeOf _object, _fnc_modifierDefault]);
