/*
    File: fn_skill_actives_fireSupport_overwhelmingFire.sqf
    Author: Savage Game Design
    Date: 2023-10-08
    Last Update: 2023-10-08
    Public: No

    Description:
        Adds logic for Recon Tier 4 Overwhelming Fire skill.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_passives_fireSupport_overwhelmingFire
 */

["Fire Support/Overwhelming Fire skill activated"] call vgm_g_fnc_logInfo;

["skill_active_sixthSense", {
    ["Fire Support/Overwhelming Fire skill exhausted"] call vgm_g_fnc_logInfo;

    [player, "suppress", "skill_fireSupport_overwhelmingFire"] call vgm_c_fnc_coefficient_remove;
    player removeEventHandler ["Fired", vgm_c_skill_actives_fireSupport_overwhelmingFire_firedEh]
}, 120, "seconds"] call BIS_fnc_runLater;

[player, "suppress", "skill_fireSupport_overwhelmingFire", 0.5] call vgm_c_fnc_coefficient_set;

vgm_c_skill_actives_fireSupport_overwhelmingFire_firedEh = player addEventHandler ["Fired", {
    params ["_unit", "_weapon", "_muzzle", "", "", "_magazine"];
    // 50% to regain bullet if it's not a grenade or explosive
    if (_weapon in ["Throw", "Put"] || selectRandom [true, false]) exitWith {};
    _unit setAmmo [_weapon, (_unit ammo _muzzle) + 1];
}];
