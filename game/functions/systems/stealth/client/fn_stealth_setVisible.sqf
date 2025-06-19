/*
    File: fn_stealth_setVisible.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-06-19
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

private _isCurrentlyVisible = [player, "camouflage", "stealth_visible"] call vgm_c_fnc_coefficient_hasReason;

// This is a very common situation in combat, this optimises this significantly by avoiding calls to other systems.
if (_isCurrentlyVisible isEqualTo _shouldBeVisible) exitWith {};

if (_shouldBeVisible) then {
    // Not persistent on respawn, as status effect will clear on respawn.
    [player, "camouflage", "stealth_visible", 1, false] call vgm_c_fnc_coefficient_set;
} else {
    [player, "camouflage", "stealth_visible"] call vgm_c_fnc_coefficient_remove;
    // Clear this as it's a maximum duration, and visibility has ended.
    vgm_c_stealth_visibleUntil = nil;
};

// TODO - Fix bug where this persists on respawn
player setVariable ["vgm_g_stealth_isVisible", _shouldBeVisible, true];
