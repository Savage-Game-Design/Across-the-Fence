/*
    File: fn_skillPresets_handle_fetchRequest.sqf
    Author: Atlas
    Date: 2026-03-03
    Public: No

    Description:
        Handle client request to fetch their presets from DB.
        Sends the presets hashmap back to the requesting client.

    Parameter(s):
        _player - Requesting player [OBJECT]

    Returns:
        Nothing
*/

params ["_player"];

if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {
    (format ["Preset fetch request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]) call vgm_g_fnc_logError;
};

private _uid = getPlayerUID _player;
private _presets = _uid call vgm_s_fnc_skillPresets_dbGet;

[_presets] remoteExecCall ["vgm_c_fnc_skillPresets_receivePresets", _player];
