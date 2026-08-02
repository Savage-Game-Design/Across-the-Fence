/*
    File: fn_skillPresets_requestSave.sqf
    Author: Atlas
    Date: 2026-03-03
    Public: No

    Description:
        Send a save preset request to the server.

    Parameter(s):
        _slotIndex - Slot index 0-4 [NUMBER]
        _name - Preset name [STRING]

    Returns:
        Nothing
*/

params ["_slotIndex", "_name"];

[player, _slotIndex, _name] remoteExecCall ["vgm_s_fnc_skillPresets_handle_saveRequest", 2];
