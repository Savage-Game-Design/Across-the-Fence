/*
    File: fn_medical_preInit.sqf
    Author: Savage Game Design
    Date: 2023-09-01
    Last Update: 2023-09-01
    Public: No

    Description:
        Global postInit for medical component.
 */

if (hasInterface) then {
    player addEventHandler ["Take", {
        params ["_unit"];
        _unit call vgm_g_fnc_medical_replaceItems;
    }];
    player addEventHandler ["InventoryOpened", {
        params ["_unit"];
        _unit call vgm_g_fnc_medical_replaceItems;
    }];
};
