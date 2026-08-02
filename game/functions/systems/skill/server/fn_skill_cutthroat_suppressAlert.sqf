/*
    File: fn_skill_cutthroat_suppressAlert.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server-side handler for the Cutthroat skill. Suppresses the next
        alertness gain from a melee kill by temporarily reducing alertness.

    Parameter(s):
        _killer - Player who performed the melee kill [OBJECT]

    Returns:
        Nothing

    Example(s):
        [_killer] call vgm_s_fnc_skill_cutthroat_suppressAlert
 */

params ["_killer"];

if (isNull _killer || !isPlayer _killer) exitWith {};

// Find the director data for the player's current mission
private _playerId = _killer getVariable ["para_g_playerIndex", ""];
if (_playerId == "") exitWith {};

private _mission = [_playerId] call vgm_s_fnc_missions_getAssignedMission;
if (isNil "_mission") exitWith {};

private _directorData = _mission getOrDefault ["directorData", createHashMap];
if (_directorData isEqualTo createHashMap) exitWith {};

// Suppress the next noise event alertness for this player's area
// by applying a small negative alertness correction
[_directorData, -2] call vgm_s_fnc_director_addAlertness;

format ["Cutthroat: Suppressed alertness gain for melee kill by %1", name _killer] call vgm_g_fnc_logInfo;
