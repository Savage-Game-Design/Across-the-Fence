/*
    File: fn_artillery_postInit.sqf
    Author: Savage Game Design
    Date: 2024-11-09
    Last Update: 2024-11-09
    Public: No

    Description:
        Initialises VN's artillery system

    Parameter(s):
        N/A

    Returns:
        N/A

    Example(s):
        [] call vgm_g_fnc_artillery_postInit
 */

if (!isNil "vn_artillery_module") exitWith {};

// The artillery system expects a physical object to be available for determining distances.
// We use an arbitrary game logic in the mission.sqm instead.
vn_artillery_module = missionNamespace getVariable "vgm_artillery_module_placeholder";

[vn_artillery_module] call vn_fnc_artillery_init;

if (hasInterface) then {
    // Add the actions on deploy, but they won't have access to them unless they're a trained RTO.
    ["vgm_mission_deploy_local", {
        [] call vgm_c_fnc_artillery_addActions;
    }] call para_g_fnc_event_subscribeLocal;

    ["vgm_mission_end_local", {
        [] call vgm_c_fnc_artillery_removeActions;
    }] call para_g_fnc_event_subscribeLocal;
};
