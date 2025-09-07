/*
    File: fn_db_save.sqf
    Author: Cerebral
    Date: 2022-11-11
    Last Update: 2025-09-07
    Public: No

    Description:
        Creates or updates a database entry from a key.

    Parameter(s):
        0: ID   - ID of the entry IE: player_76563326239693 [STRING]
        1: Data - Data for the entry [HASHMAP]

    Returns:
        0: Data saved to the database [HASHMAP]

    Example:
        private _playerUID = getPlayerUID player;
        private _playerProfile = ["player", _playerUID] call vgm_fnc_db_get;
        private _playerSkills = _playerProfile get "skills";

        _playerSkills set ["driving", 1];

        private _vgmUID = format ["%1_%2", "player", _playerUID];
        [_vgmUID, _playerProfile] call vgm_s_fnc_db_save;
*/

params ["_id", "_data"];

if !(_data isEqualType createHashMap) exitWith {
    ["ERROR", format ["VGM: Failure to save %1. Data is not a hashmap: %2", _id, _data]] call para_g_fnc_log
};
profileNamespace setVariable [format ["vgm_%1", _id], _data];

["SUCCESS", format ["VGM: Saved %1 with data: %2", _id, _data]] call para_g_fnc_log;

+_data // result
