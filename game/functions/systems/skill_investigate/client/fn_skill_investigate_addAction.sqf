/*
    File: fn_skill_investigate_addAction.sqf
    Author: Savage Game Design
    Date: 2024-01-21
    Last Update: 2025-01-16
    Public: No

    Description:
        Adds "Stop, Listen" action to the player.

    Parameter(s):
        _player - Player unit [OBJECT]

    Returns:
        Action ID [NUMBER]

    Example(s):
        player call vgm_c_fnc_skill_investigate_addAction
 */

params ["_player"];

_player addAction [
    localize "STR_VGM_SKILL_INVESTIGATE_ACTION",
    vgm_c_fnc_skill_investigate_toggleFocusMode,
    [],
    10000,
    false,
    true,
    "",
    "
        private _isFocusing = missionNamespace getVariable ['vgm_c_skill_investigate_isFocusing', false];
        _isFocusing || (call vgm_c_fnc_skill_investigate_canFocus)
    ",
    -1,
    true
]
