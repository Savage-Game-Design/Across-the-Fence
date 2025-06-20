/*
    File: fn_skill_actives_steelRain.sqf
    Author: Savage Game Design
    Date: 2023-10-08
    Last Update: 2025-06-18
    Public: No

    Description:
        Adds logic for the steel rain skill.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_steelRain
 */

params ["", "_skill"];

["Steel rain skill activated"] call vgm_g_fnc_logInfo;

["skill_actives_steelRain", {
    ["Steel rain skill exhausted"] call vgm_g_fnc_logInfo;

    player removeEventHandler ["Fired", vgm_c_skill_actives_steelRain_firedEh]
}, _skill get "duration", "seconds"] call BIS_fnc_runLater;

vgm_c_skill_actives_steelRain_firedEh = player addEventHandler ["Fired", {
    params ["_unit", "_weapon", "", "", "", "_magazine"];
    if (_weapon != "throw") exitWith {};
    _unit addMagazine _magazine;
}];
