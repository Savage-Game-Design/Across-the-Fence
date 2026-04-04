/*
    File: spectator_toggle.sqf
    Author: Savage Game Design
    Date: 2026-04-05
    Last Update: 2026-04-05
    Public: No

    Description:
        Toggles spectator mode

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_spectator_toggle;
 */

if (["IsSpectating", [player]] call BIS_fnc_EGSpectator) exitWith {
    ["Terminate", []] call BIS_fnc_EGSpectator;
};

["Initialize", [
    // Player is spectating
    player,
    // Only allow US and civilian (in case captive messes with it)
    [west, civilian],
    // Disable AI
    false
]] call BIS_fnc_EGSpectator;
