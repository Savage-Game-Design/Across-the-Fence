/*
    File: fn_skill_investigate_canFocus.sqf
    Author:
    Date: 2025-01-05
    Last Update: 2025-01-16
    Public: Yes

    Description:
        Checks if the player is eligible to focus.

    Parameter(s):
        None

    Returns:
        True if the player is able to focus [BOOL]

    Example(s):
        [] call vgm_c_fnc_skill_investigate_canFocus;
 */

vectorMagnitudeSqr velocity player < 1
