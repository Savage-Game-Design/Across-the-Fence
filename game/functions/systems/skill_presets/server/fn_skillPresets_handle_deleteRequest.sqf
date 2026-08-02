/*
    File: fn_skillPresets_handle_deleteRequest.sqf
    Author: Atlas
    Date: 2026-03-03
    Public: No

    Description:
        Handle client request to delete a preset from a slot.

    Parameter(s):
        _player - Requesting player [OBJECT]
        _slotIndex - Slot index 0-4 [NUMBER]

    Returns:
        Nothing
*/

params ["_player", "_slotIndex"];

if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {
    (format ["Preset delete request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]) call vgm_g_fnc_logError;
};

if (_slotIndex < 0 || _slotIndex > 4) exitWith {
    (format ["Invalid preset slot index %1 from %2", _slotIndex, name _player]) call vgm_g_fnc_logError;
};

private _uid = getPlayerUID _player;
private _presets = _uid call vgm_s_fnc_skillPresets_dbGet;

_presets set [str _slotIndex, nil];
[_uid, _presets] call vgm_s_fnc_skillPresets_dbSave;

(format ["Deleted preset slot %1 for %2", _slotIndex, name _player]) call vgm_g_fnc_logInfo;

// Send updated presets back to client
[_presets] remoteExecCall ["vgm_c_fnc_skillPresets_receivePresets", _player];
