/*
    File: fn_skillPresets_dbGet.sqf
    Author: Atlas
    Date: 2026-03-03
    Public: No

    Description:
        Load the skill presets hashmap from DB for a player UID.

    Parameter(s):
        _uid - Player UID [STRING]

    Returns:
        Presets hashmap [HASHMAP]

    Example(s):
        _presets = _uid call vgm_s_fnc_skillPresets_dbGet
*/

params ["_uid"];

private _presets = ["skillPresets", _uid] call vgm_s_fnc_persistence_dbGet;

// Ensure all 5 slots exist with defaults
for "_i" from 0 to 4 do {
    _presets set [str _i, nil, true];
};

_presets // return
