/*
    File: fn_skill_passives_digIn.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Dig In passive ability.
        When prone for 2+ seconds, gain -0.3 recoil and +0.2 hitShrug (20% chance
        to shrug hits). Removed instantly when standing/crouching.

    Parameter(s):
        _enable - Whether to enable or disable [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_digIn
 */

params ["_enable"];

if (!_enable) exitWith {
    private _ehId = player getVariable ["vgm_c_skill_digIn_ehId", -1];
    if (_ehId != -1) then {
        removeMissionEventHandler ["EachFrame", _ehId];
        player setVariable ["vgm_c_skill_digIn_ehId", nil];
    };

    // Cleanup coefficients if active
    if (player getVariable ["vgm_c_skill_digIn_active", false]) then {
        [player, "recoil", "skill_digIn"] call vgm_c_fnc_coefficient_remove;
        [player, "hitShrug", "skill_digIn"] call vgm_c_fnc_coefficient_remove;
        player setVariable ["vgm_c_skill_digIn_active", false];
    };

    player setVariable ["vgm_c_skill_digIn_proneStart", nil];
};

private _ehId = addMissionEventHandler ["EachFrame", {
    private _stance = stance player;

    if (_stance == "PRONE") then {
        private _proneStart = player getVariable ["vgm_c_skill_digIn_proneStart", -1];

        if (_proneStart < 0) then {
            player setVariable ["vgm_c_skill_digIn_proneStart", time];
        } else {
            if (time - _proneStart >= 2 && {!(player getVariable ["vgm_c_skill_digIn_active", false])}) then {
                [player, "recoil", "skill_digIn", -0.3, true] call vgm_c_fnc_coefficient_set;
                [player, "hitShrug", "skill_digIn", 0.2, true] call vgm_c_fnc_coefficient_set;
                player setVariable ["vgm_c_skill_digIn_active", true];
            };
        };
    } else {
        if (player getVariable ["vgm_c_skill_digIn_active", false]) then {
            [player, "recoil", "skill_digIn"] call vgm_c_fnc_coefficient_remove;
            [player, "hitShrug", "skill_digIn"] call vgm_c_fnc_coefficient_remove;
            player setVariable ["vgm_c_skill_digIn_active", false];
        };

        player setVariable ["vgm_c_skill_digIn_proneStart", -1];
    };
}];

player setVariable ["vgm_c_skill_digIn_ehId", _ehId];
