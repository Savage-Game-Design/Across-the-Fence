/*
    File: fn_respawn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2025-03-01
    Public: No

    Description:
        Global preInit for respawn component.
 */

// Allow this be overridden by publicVariable from the server for JIP players.
if (isNil "vgm_g_respawn_maximumRespawns") then {
    vgm_g_respawn_maximumRespawns = 1;
};
