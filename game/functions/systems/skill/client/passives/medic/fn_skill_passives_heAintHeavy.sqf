/*
    File: fn_skill_passives_heAintHeavy.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        When active, removes the forceWalk status effect while carrying a teammate,
        allowing the player to sprint.

    Parameter(s):
        _apply - Should skill effect be applied? [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_heAintHeavy
 */

params ["_apply"];

if (!_apply) exitWith {
    if (!isNil "vgm_c_skill_passives_heAintHeavy_eachFrameEH") then {
        removeMissionEventHandler ["EachFrame", vgm_c_skill_passives_heAintHeavy_eachFrameEH];
    };

    // Re-apply forceWalk if currently carrying
    if (player getVariable ["vgm_carry_isCarrying", false]) then {
        [player, "forceWalk", "carry"] call vgm_c_fnc_statusEffect_set;
    };
};

vgm_c_skill_passives_heAintHeavy_lastCarrying = false;
vgm_c_skill_passives_heAintHeavy_eachFrameEH = addMissionEventHandler ["EachFrame", {
    private _isCarrying = player getVariable ["vgm_carry_isCarrying", false];
    if (_isCarrying isEqualTo vgm_c_skill_passives_heAintHeavy_lastCarrying) exitWith {};

    vgm_c_skill_passives_heAintHeavy_lastCarrying = _isCarrying;

    if (_isCarrying) then {
        [player, "forceWalk", "carry"] call vgm_c_fnc_statusEffect_remove;
    };
}];
