/*
    File: fn_respawn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-11-03
    Last Update: 2025-01-17
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
            private _units = (units player - [player]) select {alive _x && {lifeState _x != "INCAPACITATED"}};
            if (_units isEqualTo []) exitWith {}; // prevent respawn if everyone is down (mission fail)
            if ((_units inAreaArray [player, ALONE_DIST, ALONE_DIST]) isEqualTo []) then {
                format ["Player %1 is downed and alone, respawning", player] call vgm_g_fnc_logInfo;
                forceRespawn player;
            };
        },
        3,
        "seconds",
        {true}, // execute condition
        {lifeState player != "INCAPACITATED"} // abort condition, checked only if code ran
    ]] call BIS_fnc_loop;
}] call para_g_fnc_event_subscribeLocal;

[true, "OnGameInterrupt", {
    call vgm_c_fnc_respawn_onPauseMenu;
}] call BIS_fnc_addScriptedEventHandler;
