/*
    File: fn_skill_investigate_setDesaturation.sqf
    Author: Savage Game Design
    Date: 2024-01-17
    Last Update: 2025-01-06
    Public: No

    Description:
        Sets desaturation PP filter.

    Parameter(s):
        _enable - Filter toggle [BOOL]

    Returns:
        Nothing

    Example(s):
        [true] call vgm_c_fnc_skill_investigate_setDesaturation
 */

params [["_enable", true, [false]]];

if (_enable) exitWith {
    terminate (missionNamespace getVariable ["vgm_c_skill_investigate_ppDisableScript", scriptNull]);

    private _lightLevel = getLighting select 1;
    private _contrast = [1, 2] select (_lightLevel <= 70);

    vgm_c_skill_investigate_ppDesaturate ppEffectAdjust [
        1,
        _contrast,
        0,
        //[0.05, 0.02, 0.03, -0.05],
        [0, 0, 0, 0],
        [0.5, 0.5, 0.5, 0.3],//[0.87, 1.08, 1.196, 0.3],
        [0.699, 0.887, 0.314, 0]
    ];

    vgm_c_skill_investigate_ppDesaturate ppEffectCommit 3;
    vgm_c_skill_investigate_ppDesaturate ppEffectEnable true;
};

vgm_c_skill_investigate_ppDesaturate ppEffectAdjust [
    1,
    1,
    0,
    [0, 0, 0, 0],
    [1, 1, 1, 1],
    [0.299, 0.587, 0.114, 0],
    [-1, -1, 0, 0, 0, 0, 0]
];
vgm_c_skill_investigate_ppDesaturate ppEffectCommit 3;
vgm_c_skill_investigate_ppDisableScript = [] spawn {
    waitUntil {ppEffectCommitted vgm_c_skill_investigate_ppDesaturate};
    vgm_c_skill_investigate_ppDesaturate ppEffectEnable false;
};
