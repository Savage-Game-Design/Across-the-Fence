/*
    File: fn_respawn_onPauseMenu.sqf
    Author: Savage Game Design
    Date: 2025-01-17
    Last Update: 2025-02-06
    Public: No

    Description:
        Handle pasue menu display being opened.

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

private _ctrlRespawn = _display displayCtrl 1010;
_ctrlRespawn ctrlEnable false;
_ctrlRespawn ctrlSetTooltip localize "STR_VGM_RESPAWN_UI_RESPAWN_BUTTON_TOOLTIP";
