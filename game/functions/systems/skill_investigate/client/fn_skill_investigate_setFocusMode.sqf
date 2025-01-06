/*
    File: fn_skill_investigate_setFocusMode.sqf
    Author:
    Date: 2025-01-05
    Last Update: 2025-01-06
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

private _isFocusing = missionNamespace getVariable ["vgm_c_skill_investigate_isFocusing", false];

if (_enable && !_isFocusing && (call vgm_c_fnc_skill_investigate_canFocus)) exitWith {
    player playActionNow "Stop";
    [true] call vgm_c_fnc_skill_investigate_setDesaturation;
    [true] call vgm_c_fnc_skill_investigate_setListenMode;
    vgm_c_skill_investigate_isFocusing = true;
    vgm_c_skill_investigate_focusPFEH = addMissionEventHandler ["EachFrame", {
        if (call vgm_c_fnc_skill_investigate_canFocus) exitWith {};

        // This should remove the event handler.
        [false] call vgm_c_fnc_skill_investigate_setFocusMode;
    }];
};


if (!_enable && _isFocusing) exitWith {
    if (!(call vgm_c_fnc_skill_investigate_canFocus)) then {
        hint localize "STR_VGM_SKILL_INVESTIGATE_NOTIFICATION_STATIONARY";
        playSoundUI ["\a3\ui_f_curator\Data\Sound\CfgSound\error02.wss", 0.1];
    };

    [false] call vgm_c_fnc_skill_investigate_setDesaturation;
    [false] call vgm_c_fnc_skill_investigate_setListenMode;
    vgm_c_skill_investigate_isFocusing = false;
};
