/*
    File: fn_teleportPlayerToHub.sqf
    Author: veteran29
    Date: 2022-12-03
    Last Update: 2024-07-21
    Public: Yes

    Description:
        Teleport player to shared hub.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_sharedHub_teleportPlayerToHub
 */

hint localize "STR_VGM_SHARED_HUB_TELEPORT_NOTIFICATION"; // TODO some generic notification function?
player setVehiclePosition [markerPos "vgm_shared_hub_respawn", [], 10];
