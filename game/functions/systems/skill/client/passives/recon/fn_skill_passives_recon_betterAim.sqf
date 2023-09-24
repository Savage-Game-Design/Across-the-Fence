/*
    File: fn_skill_passives_recon_betterAim.sqf
    Author: Savage Game Design
    Date: 2023-09-22
    Last Update: 2023-09-22
    Public: No

    Description:
        Adds logic for Recon Tier 1 Better Aim skill.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_recon_betterAim
 */

params ["_known"];

private _fnc_clearEH = {
    params ["_unit"];

    _unit removeEventHandler ["AnimDone", player getVariable ["vgm_c_skill_passives_recon_betterAimEH", -1]];
    _unit removeEventHandler ["Killed", player getVariable ["vgm_c_skill_passives_recon_betterAimKilledEH", -1]];
};

if (!_known) exitWith {
    player call _fnc_clearEH;
};

private _eh = player addEventHandler ["AnimDone", {
    params ["_unit"];

    private _stance = stance _unit;
    if (_stance == "STAND") exitWith {
        [player, "aim", "skill_recon_betterAim", 0] call vgm_c_fnc_coefficient_set;
    };

    [player, "aim", "skill_recon_betterAim", -0.5] call vgm_c_fnc_coefficient_set;
}];

player setVariable [ "vgm_c_skill_passives_recon_betterAimEH", _eh];

// AnimDone fires constantly on dead bodies
// https://feedback.bistudio.com/T175658
private _killedEH = player addEventHandler ["Killed", _fnc_clearEH];

player setVariable [ "vgm_c_skill_passives_recon_betterAimKilledEH", _killedEH];
