/*
    File: fn_skillPresets_handle_saveRequest.sqf
    Author: Atlas
    Date: 2026-03-03
    Public: No

    Description:
        Handle client request to save their current skill build to a preset slot.
        Snapshots the player's current skillPaths into the requested slot.

    Parameter(s):
        _player - Requesting player [OBJECT]
        _slotIndex - Slot index 0-4 [NUMBER]
        _name - Preset name [STRING]

    Returns:
        Nothing
*/

params ["_player", "_slotIndex", "_name"];

if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {
    (format ["Preset save request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]) call vgm_g_fnc_logError;
};

if (_slotIndex < 0 || _slotIndex > 4) exitWith {
    (format ["Invalid preset slot index %1 from %2", _slotIndex, name _player]) call vgm_g_fnc_logError;
};

private _uid = getPlayerUID _player;
private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _skillPaths = +(_skillsData get "skillPaths");

if (count _skillPaths == 0) exitWith {
    (format ["Preset save request from %1 but no skills learned", name _player]) call vgm_g_fnc_logWarning;
};

// Build the preset data
private _presetData = createHashMap;
_presetData set ["name", _name];
_presetData set ["skillPaths", _skillPaths];

// Load existing presets, update slot, save
private _presets = _uid call vgm_s_fnc_skillPresets_dbGet;
_presets set [str _slotIndex, _presetData];
[_uid, _presets] call vgm_s_fnc_skillPresets_dbSave;

(format ["Saved preset '%1' to slot %2 for %3 (%4 skills)", _name, _slotIndex, name _player, count _skillPaths]) call vgm_g_fnc_logInfo;

// Send updated presets back to client
[_presets] remoteExecCall ["vgm_c_fnc_skillPresets_receivePresets", _player];
