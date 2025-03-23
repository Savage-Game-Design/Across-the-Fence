/*
    File: fn_skill_investigate_setFocusMode.sqf
    Author: Savage Game Design
    Date: 2025-01-05
    Last Update: 2025-02-04
    Public: No

    Description:
        Enables or disables "focus mode".

        Applies listen mode, any other visual effects, and monitors the player's state
        to ensure they are eligible to remain focused.

    Parameter(s):
        _enable - Should focus mode be enabled? [BOOLEAN]

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_investigate_setFocusMode;
 */

params ["_enable"];

if (!_enable) exitWith {
    vgm_c_skill_investigate_isFocusing = false;
};

if (vgm_c_skill_investigate_isFocusing) exitWith {};
vgm_c_skill_investigate_isFocusing = true;

[
    // Condition to wait for
    {call vgm_c_fnc_skill_investigate_canFocus},
    // Code to execute
    {
        [true] call vgm_c_fnc_skill_investigate_setDesaturation;
        [true] call vgm_c_fnc_skill_investigate_setListenMode;

        // check if player can remain focused
        [
            {
                !vgm_c_skill_investigate_isFocusing
                || !(call vgm_c_fnc_skill_investigate_canFocus)
            },
            {
                vgm_c_skill_investigate_isFocusing = false;
                [false] call vgm_c_fnc_skill_investigate_setDesaturation;
                [false] call vgm_c_fnc_skill_investigate_setListenMode;
            },
            _this
        ] call vgm_g_fnc_waitUntilAndExecute;
    },
    // Arguments
    nil,
    // Timeout
    0.4,
    // Code executed on timeout
    {
        if (!vgm_c_skill_investigate_isFocusing) exitWith {};
        vgm_c_skill_investigate_isFocusing = false;
        hint localize "STR_VGM_SKILL_INVESTIGATE_NOTIFICATION_STATIONARY";
        playSoundUI ["\a3\ui_f_curator\Data\Sound\CfgSound\error02.wss", 0.1];
    }
] call vgm_g_fnc_waitUntilAndExecute;
