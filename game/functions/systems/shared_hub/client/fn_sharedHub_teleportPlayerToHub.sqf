/*
    File: fn_teleportPlayerToHub.sqf
    Author: veteran29
    Date: 2022-12-03
    Last Update: 2022-12-04
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

hint "You've wandered too far...";
player setVehiclePosition [markerPos "vgm_shared_hub", [], 10];
