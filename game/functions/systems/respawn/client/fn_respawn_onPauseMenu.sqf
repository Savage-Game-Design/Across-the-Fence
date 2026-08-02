/*
    File: fn_respawn_onPauseMenu.sqf
    Author: Savage Game Design
    Date: 2025-01-17
    Last Update: 2026-03-03
    Public: No

    Description:
        Handle pause menu display being opened.
        Disables the respawn button when the player has no remaining respawns.

    Parameter(s):
        _display - Pause menu (RscDisplayInterrupt/RscDisplayMPInterrupt) [DISPLAY]

    Returns:
        Nothing

    Example(s):
        [_display] call vgm_c_fnc_respawn_onPauseMenu
 */

#define IDC_BUTTON_RESPAWN 1010

if (isNil {call vgm_c_fnc_missions_getCurrentMission}) exitWith {};

params ["_display"];

private _ctrlRespawn = _display displayCtrl IDC_BUTTON_RESPAWN;
private _remaining = [player] call vgm_g_fnc_respawn_remainingRespawns;

if (_remaining > 0) exitWith {};

_ctrlRespawn ctrlEnable false;
_ctrlRespawn ctrlSetTooltip localize "STR_VGM_RESPAWN_UI_RESPAWN_BUTTON_TOOLTIP";
