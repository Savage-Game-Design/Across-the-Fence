/*
    File: fn_skill_actives_bulletHose.sqf
    Author: Savage Game Design
    Date: 2023-10-08
    Last Update: 2025-06-13
    Public: No

    Description:
        Activates the "Bullet hose" skill.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_bulletHose
 */

params ["", "_skill"];

["Fire Support/Bullet hose skill activated"] call vgm_g_fnc_logInfo;

["skill_bulletHose", {
    ["Fire Support/Bullet hose skill exhausted"] call vgm_g_fnc_logInfo;

    [player, "suppress", "skill_bulletHose"] call vgm_c_fnc_coefficient_remove;
    player removeEventHandler ["Fired", vgm_c_skill_actives_bulletHose_firedEh]
}, _skill get "duration", "seconds"] call BIS_fnc_runLater;

[player, "suppress", "skill_bulletHose", 1] call vgm_c_fnc_coefficient_set;

vgm_c_skill_actives_bulletHose_firedEh = player addEventHandler ["Fired", {
    params ["_unit", "_weapon", "_muzzle", "", "", "_magazine"];
    // 50% to regain bullet if it's not a grenade or explosive
    if (_weapon in ["Throw", "Put"] || selectRandom [true, false]) exitWith {};
    _unit setAmmo [_weapon, (_unit ammo _muzzle) + 1];
}];
