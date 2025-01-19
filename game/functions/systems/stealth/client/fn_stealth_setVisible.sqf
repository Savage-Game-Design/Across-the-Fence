/*
    File: fn_stealth_setVisible.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-01-19
    Public: No

    Description:
        Makes the player detectable or not.

    Parameter(s):
        _isVisible - True if the player should be visible [BOOLEAN]

    Returns:
        Nothing

    Example(s):
        [true] call vgm_c_fnc_stealth_setVisible;
 */

params ["_isVisible"];

if (_isVisible) then {
    // Not persistent on respawn, as status effect will clear on respawn.
    [player, "camouflage", "stealth_visible", 1, false] call vgm_c_fnc_coefficient_set;
    vgm_c_stealth_isVisible = true;
} else {
    [player, "camouflage", "stealth_visible"] call vgm_c_fnc_coefficient_remove;
    vgm_c_stealth_visibleUntil = nil;
    vgm_c_stealth_isVisible = false;
}

