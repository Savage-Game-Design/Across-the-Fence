/*
    File: fn_skill_passives_cutthroat.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Melee kills will not raise alertness. Monitors kills and when a melee
        kill occurs, tells the server to subtract the alertness that would have
        been gained from the kill noise.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_cutthroat
 */

params ["_known"];

// Set trait so server-side alertness system can check
player setUnitTrait ["vgm_skill_cutthroat", _known, true];
player setVariable ["vgm_g_skill_cutthroat", _known, true];

if (!_known) exitWith {
    player removeEventHandler ["Fired", player getVariable ["vgm_c_skill_passives_cutthroat_firedEh", -1]];
};

// Monitor for melee weapon use - suppress noise event for melee
private _firedEh = player addEventHandler ["Fired", {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

    // Check if weapon is a melee/knife type (bayonet attacks, knife)
    // Bayonet attacks use the weapon's muzzle name containing "bayonet" or the ammo is melee-type
    private _isMelee = "bayonet" in (toLower _muzzle) || "knife" in (toLower _ammo) || "melee" in (toLower _ammo);

    if (!_isMelee) exitWith {};

    // Tell server to suppress the next alertness gain for this kill
    [_unit] remoteExecCall ["vgm_s_fnc_skill_cutthroat_suppressAlert", 2];
}];

player setVariable ["vgm_c_skill_passives_cutthroat_firedEh", _firedEh];
