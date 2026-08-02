/*
    File: fn_skill_pileOfLeaves_hideBody.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server-side handler for the Pile of Leaves skill. When a body is hidden,
        reduces alertness to offset the alert gain from the kill.

    Parameter(s):
        _body - The dead enemy unit whose body was hidden [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_body] call vgm_s_fnc_skill_pileOfLeaves_hideBody
 */

params ["_body"];

if (isNull _body) exitWith {};

// Find the nearest active mission's director data
private _allMissions = values (missionNamespace getVariable ["vgm_s_missions_allMissions", createHashMap]);
private _directorData = createHashMap;

{
    private _mDir = _x getOrDefault ["directorData", createHashMap];
    if !(_mDir isEqualTo createHashMap) exitWith {
        _directorData = _mDir;
    };
} forEach _allMissions;

if (_directorData isEqualTo createHashMap) exitWith {};

// Reduce alertness to offset the kill's noise contribution
[_directorData, -3] call vgm_s_fnc_director_addAlertness;

format ["Pile of Leaves: Alertness reduced for hidden body %1", typeOf _body] call vgm_g_fnc_logInfo;
