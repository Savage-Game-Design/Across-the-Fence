/*
    File: fn_sites_hints_initObject.sqf
    Author: Savage Game Design
    Date: 2024-10-27
    Last Update: 2024-10-30
    Public: No

    Description:
        Initialize hint object.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_c_fnc_sites_hints_initObject
 */

params ["_object", "_args"];
_args params ["_sitePos"];

vgm_sites_hints_objectsList pushBack _object;

_object addAction [
    "Inspect",
    {},
    nil,
    100,
    true,
    true,
    "",
    toString {true},
    3
];

