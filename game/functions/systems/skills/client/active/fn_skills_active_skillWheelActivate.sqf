/*
    File: fn_skills_active_skillWheelActivate.sqf
    Author:
    Date: 2023-02-01
    Last Update: 2025-11-29
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
    (format ["Cannot activate skill - on cooldown: %1", _skill get "path"]) call vgm_g_fnc_logWarning;
    hint "Skill on cooldown!";
};

if (_slot call vgm_c_fnc_skills_active_isSlotActive) exitWith {
    (format ["Cannot activate skill - already active: %1", _skill get "path"]) call vgm_g_fnc_logWarning;
    hint "Skill active!";
};

if (false isEqualTo call (_skill get "conditionActivate")) exitWith {
    (format ["Unable to activate", _skill get "path"]) call vgm_g_fnc_logWarning;
    player call (_skill get "codeUnableToActivate");
};

[player, _skill] call (_skill get "codeActivate");
[player, _skill get "path"] remoteExecCall ["vgm_c_fnc_skills_active_applyGroupSkill", [] call vgm_c_fnc_missions_getTeamMembers];

private _duration = _skill get "duration";
private _activeUntil = time + _duration;
_slot set ["activeTime", _duration];
_slot set ["activeUntil", _activeUntil];

private _cooldownTime = (_skill get "cooldown") * (player getVariable ["vgm_c_skills_cooldownCoef", 1]);
// TODO remember cooldowns to prevent resetting by doing a reconnect
private _cooldownUntil = time + _cooldownTime;
_slot set ["cooldownTime", _cooldownTime];
// Ensure cooldown is never faster than the duration so it can't be re-triggered when already active.
_slot set ["cooldownUntil", _cooldownUntil];

["vgm_skills_active_activated", [_slot get "name", _skill]] call para_g_fnc_event_triggerLocal;

private _jobId = format ["skill_%1", _skill get "path" select -1];
[
    _jobId,
    {
        params ["_skill"];
        [format ["Skill %1 ended", (_skill get "displayName") call para_c_fnc_localize]] call vgm_g_fnc_logInfo;
        [player, _skill] call (_skill get "codeDeactivate");
    },
    [_skill],
    // No tick delay - job only runs once
    0,
    // Single iteration
    1,
    // Delay before running job
    _duration
] call para_g_fnc_scheduler_add_job;
