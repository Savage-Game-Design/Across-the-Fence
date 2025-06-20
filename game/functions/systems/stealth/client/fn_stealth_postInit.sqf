/*
    File: fn_stealth_postInit.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-06-20
    Public: No

    Description:
        Postinit for the stealth system.

*/

if (!hasInterface) exitWith {};

vgm_c_stealth_perFrameEH = addMissionEventHandler ["EachFrame", {call vgm_c_fnc_stealth_eachFrame}];

[player] call vgm_c_fnc_stealth_addPlayerFiredEH;
player addEventHandler ["Respawn", {
    [] call vgm_c_fnc_stealth_addPlayerFiredEH;
    [false] call vgm_c_fnc_stealth_setVisible;
}];
