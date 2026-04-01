/*
    File: fn_skills_handle_recalculateSkillPoints.sqf
    Author: Savage Game Design
    Date: 2026-04-01
    Last Update: 2026-04-01
    Public: No

    Description:
        Handle client request to recalculate skill points after a discount change.

    Parameter(s):
        _player - Player to recalculate for [OBJECT]

    Returns:
        Nothing
 */

params ["_player"];

if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {
    (format ["Recalculate request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]) call vgm_g_fnc_logError;
};

[_player] call vgm_s_fnc_skills_recalculateSkillPoints;
