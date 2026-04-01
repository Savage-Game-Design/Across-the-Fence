/*
    File: fn_skill_passives_addAircraft_preInit.sqf
    Author: Savage Game Design
    Date: 2026-01-25
    Last Update: 2026-01-25
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

if (!hasInterface) exitWith {};

vgm_c_skill_passives_addAircraft_aircraftIds = [];

["vgm_mission_deploy_local", {
    [getPlayerID player, vgm_c_skill_passives_addAircraft_aircraftIds] remoteExecCall ["vgm_s_fnc_rto_addAvailableAircraft", 2];
}] call para_g_fnc_event_subscribeLocal;

["vgm_mission_end_local", {
    [getPlayerID player] remoteExecCall ["vgm_s_fnc_rto_clearAvailableAircraft", 2];
}] call para_g_fnc_event_subscribeLocal;
