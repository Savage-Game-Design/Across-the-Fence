/*
    File: fn_respawn_postInit.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2025-03-05
    Public: No

    Description:
        Client postInit for respawn component.
 */

[player] call vgm_c_fnc_respawn_addHoldAction;
player addEventHandler ["Respawn", { (_this#0) call vgm_c_fnc_respawn_addHoldAction }];
player setVariable ["vgm_g_respawn_respawnsUsed", 0, true];
