/*
    File: fn_stealth_setVisible.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-06-18
    Public: No

    Description:
        Makes the player detectable or not.

    Parameter(s):
        _shouldBeVisible - True if the player should be visible [BOOLEAN]

    Returns:
        Nothing

    Example(s):
        [true] call vgm_c_fnc_stealth_setVisible;
 */

params ["_shouldBeVisible"];

private _currentlyVisible = [player, "camouflage", "stealth_visible"] call vgm_c_fnc_coefficient_hasReason;

if (_shouldBeVisible && !_currentlyVisible) exitWith {
    // Not persistent on respawn, as status effect will clear on respawn.
    [player, "camouflage", "stealth_visible", 1, false] call vgm_c_fnc_coefficient_set;
};

if (!_shouldBeVisible && _currentlyVisible) exitWith {
    [player, "camouflage", "stealth_visible"] call vgm_c_fnc_coefficient_remove;
    // Clear this as it's a maximum duration, and visibility has ended.
    vgm_c_stealth_visibleUntil = nil;
};


