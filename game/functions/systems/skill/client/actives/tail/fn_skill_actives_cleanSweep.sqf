/*
    File: fn_skill_actives_cleanSweep.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail active — Clean Sweep. For 30s, all group members leave no
        trail. Sets vgm_g_skill_cleanSweep_active on each group member
        (public variable). The tracking system checks this variable and
        skips recording tracks for units that have it.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_c_fnc_skill_actives_cleanSweep
 */

params ["", "_skill"];

["Tail/Clean Sweep skill activated"] call vgm_g_fnc_logInfo;

// Set cleanSweep active on all group members
private _groupUnits = units group player;
{
    _x setVariable ["vgm_g_skill_cleanSweep_active", true, true];
} forEach _groupUnits;

// Remove after duration
["skill_cleanSweep", {
    ["Tail/Clean Sweep skill exhausted"] call vgm_g_fnc_logInfo;

    private _groupUnits = units group player;
    {
        _x setVariable ["vgm_g_skill_cleanSweep_active", false, true];
    } forEach _groupUnits;
}, _skill get "duration", "seconds"] call BIS_fnc_runLater;
