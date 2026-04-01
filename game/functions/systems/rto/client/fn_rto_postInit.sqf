/*
    File: fn_rto_postInit.sqf
    Author: Savage Game Design
    Date: 2024-11-09
    Last Update: 2026-01-25
    Public: No

    Description:
        Client postInit for the RTO system
 */

if (hasInterface) then {
    // Add the actions on deploy, but they won't have access to them unless they're a trained RTO.
    ["vgm_mission_deploy_local", {
        [] call vgm_c_fnc_rto_addActions;
    }] call para_g_fnc_event_subscribeLocal;

    ["vgm_mission_end_local", {
        [] call vgm_c_fnc_rto_removeActions;
    }] call para_g_fnc_event_subscribeLocal;
};
