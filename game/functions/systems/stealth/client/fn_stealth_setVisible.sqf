/*
    File: fn_stealth_setVisible.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-04-05
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

private _isCurrentlyVisible = player getVariable ["vgm_g_stealth_isVisible", false];
// This is a very common situation in combat, this optimises this significantly by avoiding calls to other systems.
if (_isCurrentlyVisible isEqualTo _isVisible) exitWith {};

if (_isVisible) exitWith {
    // Not persistent on respawn, as status effect will clear on respawn.
    [player, "camouflage", "stealth_visible", 1, false] call vgm_c_fnc_coefficient_set;
    player setVariable ["vgm_g_stealth_isVisible", true, true];
};

[player, "camouflage", "stealth_visible"] call vgm_c_fnc_coefficient_remove;
player setVariable ["vgm_g_stealth_isVisible", false, true];
// Clear this as it's a maximum duration, and visibility has ended.
vgm_c_stealth_visibleUntil = nil;

