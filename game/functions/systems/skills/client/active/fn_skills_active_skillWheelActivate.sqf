/*
    File: fn_skills_active_skillWheelActivate.sqf
    Author:
    Date: 2023-02-01
    Last Update: 2023-09-24
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
    (format ["Skill on cooldown`", _skill get "path"]) call vgm_g_fnc_logWarning;
    hint "Skill on cooldown!";
};

player call (_skill get "codeActivate");

private _cooldownTime = (_skill get "cooldown") * (player getVariable ["vgm_c_skills_cooldownCoef", 1]);
// TODO remember cooldowns to prevent resetting by doing a reconnect
private _cooldownUntil = time + _cooldownTime;
_slot set ["cooldownTime", _cooldownTime];
_slot set ["cooldownUntil", _cooldownUntil];

["vgm_skills_active_activated", [_slot get "name", _skill]] call para_g_fnc_event_triggerLocal;
