/*
    File: fn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2023-06-02
    Public: No

    Description:
        Server preInit function for leveling system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!isServer) exitWith {};

["vgm_leveling_init", {
    params ["_player"];

    if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {
        (format ["Leveling data request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]) call vgm_g_fnc_logError;
    };

    ["DEBUG", format ["Received player leveling init request %1 (%2)", name _player, getPlayerUID _player]] call vgm_g_fnc_log;

    [_player, 0] call vgm_s_fnc_leveling_addExperience;
}] call para_g_fnc_event_subscribe;
