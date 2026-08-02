/*
    File: fn_preInit.sqf
    Author: Savage Game Design
    Date: 2023-05-30
    Last Update: 2023-06-23
    Public: No

    Description:
        Server preInit function for leveling system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!isServer) exitWith {};

// XP loss: death penalty (-50), friendly fire (-100 to killer), team wipe (-75 to all)
addMissionEventHandler ["EntityKilled", {
    params ["_unit", "_killer", "_instigator"];
    if (!isPlayer _unit) exitWith {};
    if !(_unit isKindOf "CAManBase") exitWith {};

    // Death penalty: -50 XP to the player who died
    [_unit, -50] call vgm_s_fnc_leveling_addExperience;
    (format ["XP PENALTY: Death -50 XP to %1", name _unit]) call vgm_g_fnc_logInfo;

    // Friendly fire penalty: -100 XP to the killer
    if (!isNull _instigator) then {_killer = _instigator};
    if (isPlayer _killer && {_killer != _unit} && {side group _killer == side group _unit}) then {
        [_killer, -100] call vgm_s_fnc_leveling_addExperience;
        (format ["XP PENALTY: Friendly fire -100 XP to %1 for killing %2", name _killer, name _unit]) call vgm_g_fnc_logInfo;
    };

    // Team wipe check: if all players in the group are dead, apply -75 XP to each
    private _group = group _unit;
    private _alivePlayers = (units _group) select {isPlayer _x && alive _x};
    if (_alivePlayers isEqualTo []) then {
        {
            if (isPlayer _x) then {
                [_x, -75] call vgm_s_fnc_leveling_addExperience;
                (format ["XP PENALTY: Team wipe -75 XP to %1", name _x]) call vgm_g_fnc_logInfo;
            };
        } forEach (units _group);
    };
}];

["vgm_leveling_init", {
    params ["_player"];

    if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {
        (format ["Leveling data request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]) call vgm_g_fnc_logError;
    };

    ["DEBUG", format ["Received player leveling init request %1 (%2)", name _player, getPlayerUID _player]] call vgm_g_fnc_log;

    // broadcast data to the client and trigger level up from 0 to 1 for fresh profiles
    [_player, 0] call vgm_s_fnc_leveling_addExperience;
}] call para_g_fnc_event_subscribe;
