/*
    File: fn_skillPresets_dbSave.sqf
    Author: Atlas
    Date: 2026-03-03
    Public: No

    Description:
        Save the skill presets hashmap to DB for a player UID.

    Parameter(s):
        _uid - Player UID [STRING]
        _presets - Presets hashmap [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_uid, _presets] call vgm_s_fnc_skillPresets_dbSave
*/

params ["_uid", "_presets"];

["skillPresets", _uid, _presets] call vgm_s_fnc_persistence_dbSet;
