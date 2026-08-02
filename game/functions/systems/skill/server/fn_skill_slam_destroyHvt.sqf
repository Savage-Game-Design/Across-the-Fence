/*
    File: fn_skill_slam_destroyHvt.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server handler for SLAM skill. Destroys the target infrastructure
        and awards 75 XP to the player.

    Parameter(s):
        _target - The infrastructure object to destroy [OBJECT]
        _caller - The player who placed the charges [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_target, _caller] remoteExecCall ["vgm_s_fnc_skill_slam_destroyHvt", 2]
 */

if (!isServer) exitWith {};

params ["_target", "_caller"];

_target setVariable ["vgm_slam_destroyed", true];
_target setDamage 1;
[_caller, 75] call vgm_s_fnc_leveling_addExperience;

format ["SLAM: %1 destroyed HVT %2 at %3", name _caller, typeOf _target, getPos _target] call vgm_g_fnc_logInfo;
