/*
    File: fn_skillPresets_requestDelete.sqf
    Author: Atlas
    Date: 2026-03-03
    Public: No

    Description:
        Send a delete preset request to the server.

    Parameter(s):
        _slotIndex - Slot index 0-4 [NUMBER]

    Returns:
        Nothing
*/

params ["_slotIndex"];

[player, _slotIndex] remoteExecCall ["vgm_s_fnc_skillPresets_handle_deleteRequest", 2];
