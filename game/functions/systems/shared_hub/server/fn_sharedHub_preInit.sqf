/*
    File: fn_sharedHub_preInit.sqf
    Author: Savage Game Design
    Date: 2024-03-02
    Last Update: 2024-03-02
    Public: No

    Description:
        Shared Hub server preInit.
 */

addMissionEventHandler ["HandleDisconnect", {
    params ["_unit"];

    if (_unit inArea "vgm_shared_hub") then {
        deleteVehicle _unit;
    };
}];
