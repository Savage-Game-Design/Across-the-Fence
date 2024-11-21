/*
    File: fn_tutorial_trigger.sqf
    Author: Savage Game Design
    Date: 2024-11-17
    Last Update: 2024-11-17
    Public: Yes

    Description:
        Makes the given tutorial appear.

    Parameter(s):
        _category - Tutorial category [STRING]
        _tutorialName - Name of the tutorial [STRING]

    Returns:
        Nothing

    Example(s):
        ["Tutorial", "Tutorial1"] call vgm_c_fnc_tutorial_trigger;
 */

params ["_category", "_tutorialName"];

private _key = [_category, _tutorialName];

if (_key in vgm_c_tutorial_seenTutorials) exitWith {};

[_category, _tutorialName] call para_c_fnc_ui_hints_show_hint;

vgm_c_tutorial_seenTutorials set [_key, true];
