/*
    File: fn_skill_passives_ditchRucks.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2025-11-20
    Public: No

    Description:
        When active, prevents stamina drain when the local player isn't wearing a backpack.

    Parameter(s):
        _apply - Should skill effect be applied? [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_ditchRucks
 */

params ["_apply"];

if (!_apply) exitWith {
    removeMissionEventHandler ["EachFrame", vgm_c_skill_passives_ditchRucks_eachFrameEH];
    [player, "staminaDrain", "skill_passives_ditchRucks"] call vgm_c_fnc_coefficient_remove;
};

vgm_c_skill_passives_ditchRucks_lastBackpack = "THIS IS A NON-EXISTENT BACKPACK FOR THE INITIAL COMPARISON";
vgm_c_skill_passives_ditchRucks_eachFrameEH = addMissionEventHandler ["EachFrame", {
    // Only run on backpack changes - 99.9% of the time this handler will have no work to do.
    if (backpack player isEqualTo vgm_c_skill_passives_ditchRucks_lastBackpack) exitWith {};

    private _backpack = backpack player;
    vgm_c_skill_passives_ditchRucks_lastBackpack = _backpack;

    if (_backpack isEqualTo "") then {
        [player, "staminaDrain", "skill_passives_ditchRucks", -1, true] call vgm_c_fnc_coefficient_set;
    } else {
        [player, "staminaDrain", "skill_passives_ditchRucks"] call vgm_c_fnc_coefficient_remove;
    };
}];
