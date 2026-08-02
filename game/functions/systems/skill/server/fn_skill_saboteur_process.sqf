/*
    File: fn_skill_saboteur_process.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server handler for Saboteur skill. Destroys the target silently,
        awards 100 XP, and reduces mission alertness by -4.

    Parameter(s):
        _target - The infrastructure object to sabotage [OBJECT]
        _caller - The player who sabotaged it [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_target, _caller] remoteExecCall ["vgm_s_fnc_skill_saboteur_process", 2]
 */

if (!isServer) exitWith {};

params ["_target", "_caller"];

_target setVariable ["vgm_saboteur_destroyed", true];
_target setDamage 1;
[_caller, 100] call vgm_s_fnc_leveling_addExperience;

// Reduce alertness
private _allMissions = values (missionNamespace getVariable ["vgm_s_missions_allMissions", createHashMap]);
private _directorData = createHashMap;

{
    private _mDir = _x getOrDefault ["directorData", createHashMap];
    if !(_mDir isEqualTo createHashMap) exitWith {
        _directorData = _mDir;
    };
} forEach _allMissions;

if !(_directorData isEqualTo createHashMap) then {
    [_directorData, -5] call vgm_s_fnc_director_addAlertness;
};

format ["Saboteur: %1 sabotaged %2 at %3 (alertness -5)", name _caller, typeOf _target, getPos _target] call vgm_g_fnc_logInfo;
