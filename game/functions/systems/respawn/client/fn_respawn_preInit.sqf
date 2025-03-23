/*
    File: fn_respawn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2025-03-23
    Public: No

    Description:
        Client preInit for respawn component.
 */

[true, "OnGameInterrupt", {
    call vgm_c_fnc_respawn_onPauseMenu;
}] call BIS_fnc_addScriptedEventHandler;

// Reset the player's respawn counter on mission start.
[
    "vgm_mission_deploy_local",
    {
        player setVariable ["vgm_g_respawn_respawnsUsed", 0, true];
    }
] call para_g_fnc_event_subscribeLocal;
