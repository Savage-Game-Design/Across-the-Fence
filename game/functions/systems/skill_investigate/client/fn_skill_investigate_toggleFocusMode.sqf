/*
    File: fn_skill_investigate_toggleFocusMode.sqf
    Author:
    Date: 2025-01-05
    Last Update: 2025-01-06
    Public: No

    Description:
        Toggles "focus mode".

        See "vgm_c_fnc_skill_investigate_setFocusMode" for more information.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_investigate_toggleFocusMode;
 */

private _isFocusing = missionNamespace getVariable ["vgm_c_skill_investigate_isFocusing", false];

[!_isFocusing] call vgm_c_fnc_skill_investigate_setFocusMode;
