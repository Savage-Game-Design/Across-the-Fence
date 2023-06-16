/*
    File: fn_skills_active_skillWheelActivate.sqf
    Author:
    Date: 2023-02-01
    Last Update: 2023-05-14
    Public: No

    Description:
        Run skill activate code from skill wheel.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [_skill] call vgm_c_fnc_skills_active_skillWheelActivate
 */

(_this#1) params ["_slot", "_skill"];

if (_skill isEqualTo createHashMap) exitWith {};

if (_slot call vgm_c_fnc_skills_active_isSlotOnCooldown) exitWith {
    ["WARNING", format ["VGM: Skill on cooldown`", _skill get "path"]] call para_g_fnc_log;
    hint "Skill on cooldown!";
};

player call (_skill get "codeActivate");
private _cooldownUntil = time + (_skill get "cooldown"); // cooldown handling probably should be server-sided as well.
_slot set ["cooldownUntil", _cooldownUntil];

["vgm_skills_active_activated", [_slot get "name", _skill]] call para_g_fnc_event_triggerLocal;
