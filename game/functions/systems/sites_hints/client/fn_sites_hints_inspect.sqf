/*
    File: fn_sites_hints_inspect.sqf
    Author: Savage Game Design
    Date: 2025-08-18
    Last Update: 2025-08-23
    Public: No

    Description:
        Inspects the provided hint object.

    Parameter(s):
        _object - Hint object to inspect [OBJECT]

    Returns:
        Nothing

    Example(s):
        [cursorObject] call vgm_c_fnc_sites_hints_inspect;
 */

params ["_object"];

if (isNil "_object") exitWith {};

private _sitePos = _object getVariable "vgm_sites_hints_sitePos";

if (isNil "_sitePos") exitWith {};

hint format [
    "Near the object you see tracks leading towards %1",
    [_object, _sitePos] call vgm_g_fnc_spokenDirection
];

[
    "vgm_sites_hints_inspected",
    [
        ([] call vgm_c_fnc_missions_getCurrentMission) get "id",
        _object getVariable "vgm_mission_objects_id",
        player getUnitTrait "vgm_sites_hints_markHintsOnMap"
    ]
] call para_g_fnc_event_triggerServer;

