/*
    File: fn_skill_passives_jungleEyes.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail passive — Jungle Eyes. Doubles the trap detection scan radius
        from 4m to 8m by setting a variable that trapDisarm and trapDetect
        read at runtime.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_jungleEyes
 */

params ["_known"];

player setUnitTrait ["vgm_skill_jungleEyes", _known, true];
player setVariable ["vgm_g_skill_jungleEyes", _known, true];

if (_known) then {
    vgm_c_skill_trapScanRadius = 8;
} else {
    vgm_c_skill_trapScanRadius = 4;
};
