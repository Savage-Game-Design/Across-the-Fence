/*
    File: fn_sites_hints_initObject.sqf
    Author: Savage Game Design
    Date: 2024-10-27
    Last Update: 2024-12-16
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

_object setVariable ["vgm_sites_hints_sitePos", _sitePos];

_object addAction [
    "Inspect",
    {
        params ["_object", "", "", "_args"];
        _args params ["_sitePos"];

        hint format [
            "Near the object you see tracks leading towards %1",
            [_object, _sitePos] call vgm_g_fnc_spokenDirection
        ];

        [
            "vgm_sites_hints_inspected",
            [
                ([] call vgm_c_fnc_missions_getCurrentMission) get "id",
                _object getVariable "vgm_mission_objects_id"
            ]
        ] call para_g_fnc_event_triggerServer;
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
