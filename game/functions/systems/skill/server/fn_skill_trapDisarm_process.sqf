/*
    File: fn_skill_trapDisarm_process.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server handler for punji trap disarm action. Deletes the mine
        and awards 25 XP to the player who disarmed it.

    Parameter(s):
        _target - The mine that was disarmed [OBJECT]
        _caller - The player who disarmed the trap [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_target, _caller] remoteExecCall ["vgm_s_fnc_skill_trapDisarm_process", 2]
 */

if (!isServer) exitWith {};

params ["_target", "_caller"];

private _pos = getPos _target;
deleteVehicle _target;
[_caller, 25] call vgm_s_fnc_leveling_addExperience;

format ["Punji trap: %1 disarmed trap at %2", name _caller, _pos] call vgm_g_fnc_logInfo;
