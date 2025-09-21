/*
    File: fn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2025-09-21
    Public: No

    Description:
        Client preInit function for leveling system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!hasInterface) exitWith {};

["leveling"] call vgm_c_fnc_persistence_registerSchema;

["vgm_leveling_updateData", {
    params ["_levelingData"];

    player setVariable ["vgm_g_levelingData", _levelingData];
}] call para_g_fnc_event_subscribeServer;

["leveling", {
    !isNil {player getVariable "vgm_g_levelingData"}
}] call vgm_c_fnc_loading_addHandler;

["vgm_shared_hub_enabled", {
    [] spawn {
        waitUntil {!isNil {player getVariable "vgm_g_levelingData"}};
        "VGM_LevelIndicator" cutRsc ["VGM_RscLevelIndicator", "PLAIN", -1, false];
    };
}] call para_g_fnc_event_subscribeLocal;

["vgm_shared_hub_disabled", {
    "VGM_LevelIndicator" cutFadeOut 2;
}] call para_g_fnc_event_subscribeLocal;
