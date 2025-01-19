/*
    File: fn_stealth_postInit.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-01-19
    Public: No

    Description:
        Postinit for the stealth system.

*/

["visible", {call vgm_c_fnc_stealth_setVisible}] call vgm_c_fnc_statusEffect_create;

vgm_c_stealth_perFrameEH = addMissionEventHandler ["EachFrame", {call vgm_c_fnc_stealth_eachFrame}];
