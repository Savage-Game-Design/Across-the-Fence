/*
    File: fn_skill_eldestSon_plantBoobyTrap.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server handler for Eldest Son booby-trap action. Awards bonus XP
        and marks the ammo box as trapped.

    Parameter(s):
        _target - The ammo box that was trapped [OBJECT]
        _caller - The player who planted the trap [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_target, _caller] remoteExecCall ["vgm_s_fnc_skill_eldestSon_plantBoobyTrap", 2]
 */

if (!isServer) exitWith {};

params ["_target", "_caller"];

_target setVariable ["vgm_eldestSon_trapped", true, true];
[_caller, 50] call vgm_s_fnc_leveling_addExperience;

format ["Eldest Son: %1 planted booby-trapped ammo at %2", name _caller, getPos _target] call vgm_g_fnc_logInfo;
