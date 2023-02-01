/*
    File: fn_skills_active_skillWheelActivate.sqf
    Author:
    Date: 2023-02-01
    Last Update: 2023-02-01
    Public: No

    Description:
        Run skill skill activate from skill wheel.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [_skill] call vgm_c_fnc_skills_active_skillWheelActivate
 */

(_this#1) params ["_slot", "_skill"];

if (_slot call vgm_c_fnc_skills_active_isSlotOnCooldown) exitWith {
    ["WARNING", format ["VGM: Skill on cooldown`", _skill get "path"]] call para_g_fnc_log;
    hint "Skill on cooldown!";
};

player call (_skill get "codeActivate");
private _cooldown = time + ([30, 60] select (_skill get "isUltimate"));
_slot set ["cooldown", _cooldown];
