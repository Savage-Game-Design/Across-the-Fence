/*
    File: fn_respawn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2023-11-03
    Public: No

    Description:
        Client preInit for respawn component.
 */

#define ALONE_DIST 250

["vgm_medical_unconscious", {
    (_this#0) params ["_unit", "_state"];
    if (_unit != player || !_state) exitWith {};

    ["itemAdd", [
        "vgm_respawn_isAlone",
        {
            format ["Player %1 is downed and alone, respawning", player] call vgm_g_fnc_logInfo;
            forceRespawn player;
        },
        3,
        "seconds",
        {((units player inAreaArray [player, ALONE_DIST, ALONE_DIST]) - [player]) isEqualTo []}, // execute condition
        {lifeState player != "INCAPACITATED"}, // abort condition
        true // execute once
    ]] call BIS_fnc_loop;
}] call para_g_fnc_event_subscribeLocal;
