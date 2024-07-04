/*
    File: fn_skill_actives_fireSupport_grenadesCase.sqf
    Author: Savage Game Design
    Date: 2023-10-08
    Last Update: 2024-07-03
    Public: No

    Description:
        Adds logic for Recon Tier 3 Grenades Case skill.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_fireSupport_grenadesCase
 */

params ["", "_skill"];

["Fire Support/Grenades Case skill activated"] call vgm_g_fnc_logInfo;

["skill_actives_fireSupport_grenadesCase", {
    ["Fire Support/Grenades Case skill exhausted"] call vgm_g_fnc_logInfo;

    player removeEventHandler ["Fired", vgm_c_skill_actives_fireSupport_grenadesCase_firedEh]
}, _skill get "duration", "seconds"] call BIS_fnc_runLater;

vgm_c_skill_actives_fireSupport_grenadesCase_firedEh = player addEventHandler ["Fired", {
    params ["_unit", "_weapon", "", "", "", "_magazine"];
    if (_weapon != "throw") exitWith {};
    _unit addMagazine _magazine;
}];
