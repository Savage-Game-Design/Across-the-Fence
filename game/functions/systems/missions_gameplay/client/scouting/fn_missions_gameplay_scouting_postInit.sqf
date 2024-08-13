/*
    File: fn_mission_gameplay_scouting_postInit.sqf
    Author: Savage Game Design
    Date: 2024-08-09
    Last Update: 2024-08-11
    Public: No

    Description:
        client Post init for mission gameplay scouting system.
 */

if (!hasInterface) exitWith {};

[true, "vn_photoCamera_pictureTaken", {
    params ["_cursorTarget"];
    if !(_cursorTarget getVariable ["vgm_spottable", false]) exitWith {};

    ["vgm_spottedTarget", [player, _cursorTarget]] call para_g_fnc_event_triggerServer;

}] call BIS_fnc_addScriptedEventHandler;
