/*
    File: fn_skill_passives_stablePlatform.sqf
    Author: Savage Game Design
    Date: 2023-09-22
    Last Update: 2025-06-13
    Public: No

    Description:
        Adds behaviour for "Stable platform" skill

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_stablePlatform
 */

params ["_known"];

private _fnc_clearEH = {
    params ["_unit"];

    _unit removeEventHandler ["AnimDone", player getVariable ["vgm_c_skill_passives_stablePlatformEH", -1]];
    _unit removeEventHandler ["Killed", player getVariable ["vgm_c_skill_passives_stablePlatformKilledEH", -1]];
};

if (!_known) exitWith {
    player call _fnc_clearEH;
};

private _eh = player addEventHandler ["AnimDone", {
    params ["_unit"];

    // TODO reading the stance from anim name could be more reliable
    private _stance = stance _unit;
    private _lastStance = _unit getVariable ["vgm_c_skill_passives_stablePlatform_lastStance", ""];
    // optimize by not calling coefficient functions if stance did not change
    if (_stance isEqualTo _lastStance) exitWith {};
    _unit setVariable ["vgm_c_skill_passives_stablePlatform_lastStance", _stance];

    if (_stance == "STAND") exitWith {
        [player, "aim", "skill_stablePlatform"] call vgm_c_fnc_coefficient_remove;
    };

    [player, "aim", "skill_stablePlatform", -0.5] call vgm_c_fnc_coefficient_set;
}];

player setVariable [ "vgm_c_skill_passives_stablePlatformEH", _eh];

// AnimDone fires constantly on dead bodies
// https://feedback.bistudio.com/T175658
private _killedEH = player addEventHandler ["Killed", _fnc_clearEH];

player setVariable [ "vgm_c_skill_passives_stablePlatformKilledEH", _killedEH];
