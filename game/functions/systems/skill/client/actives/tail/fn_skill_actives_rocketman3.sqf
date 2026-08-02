/*
    File: fn_skill_actives_rocketman3.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail active — Rocketman 3 (4th of July). For 30s, firing AT
        weapons (M72 LAW, M20 Super Bazooka) does not consume ammo.
        Uses the Bullet Hose pattern with a Fired EH.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_c_fnc_skill_actives_rocketman3
 */

params ["", "_skill"];

["Tail/Rocketman 3 skill activated"] call vgm_g_fnc_logInfo;

private _atWeapons = ["vn_m72", "vn_m20a1b1_01"];

["skill_rocketman3", {
    ["Tail/Rocketman 3 skill exhausted"] call vgm_g_fnc_logInfo;
    player removeEventHandler ["Fired", vgm_c_skill_actives_rocketman3_firedEh];
}, _skill get "duration", "seconds"] call BIS_fnc_runLater;

vgm_c_skill_actives_rocketman3_firedEh = player addEventHandler ["Fired", {
    params ["_unit", "_weapon", "_muzzle", "", "", "_magazine"];

    private _atWeapons = ["vn_m72", "vn_m20a1b1_01"];
    if !(_weapon in _atWeapons) exitWith {};

    // Restore the fired ammo
    _unit setAmmo [_weapon, (_unit ammo _muzzle) + 1];
}];
