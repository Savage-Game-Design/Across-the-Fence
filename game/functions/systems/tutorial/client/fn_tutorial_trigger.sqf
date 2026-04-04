/*
    File: fn_tutorial_trigger.sqf
    Author: Savage Game Design
    Date: 2024-11-17
    Last Update: 2026-04-04
    Public: Yes

    Description:
        Makes the given tutorial appear.

    Parameter(s):
        _category - Tutorial category [STRING]
        _pageName - Name of the tutorial [STRING]

    Returns:
        Nothing

    Example(s):
        ["Tutorial", "Tutorial1"] call vgm_c_fnc_tutorial_trigger;
        ["vgm", "missions", "create_mission"] call vgm_c_fnc_tutorial_trigger;
 */

params ["_category", "_pageName", ["_hintName", ""]];

private _key = [_category, _pageName, _hintName];

if (_key in vgm_c_tutorial_seenTutorials || vgm_g_tutorial_disable) exitWith {};

[_category, _pageName, _hintName] call para_c_fnc_ui_hints_show_hint;

vgm_c_tutorial_seenTutorials set [_key, true];

missionProfileNamespace setVariable ["vgm_tutorial_seenTutorials", vgm_c_tutorial_seenTutorials];
saveMissionProfileNamespace;
