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

    // if this EH code returns true... player... becomes AI
    // https://community.bistudio.com/wiki/Arma_3:_Mission_Event_Handlers#HandleDisconnect
    false
}];
