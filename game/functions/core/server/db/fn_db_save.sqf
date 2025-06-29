/*
    File: fn_db_save.sqf
    Author: Cerebral
    Date: 2022-11-11
    Last Update: 2025-06-29
    Public: No

    Description:
        Creates or updates a database entry from a key.

    Parameter(s):
        0: ID   - ID of the entry IE: player_76563326239693 [STRING]
        1: Data - Data for the entry [HASHMAP]

    Returns:
        Nothing

    Example:
        private _playerUID = getPlayerUID player;
        private _playerProfile = ["player", _playerUID] call vgm_fnc_db_get;
        private _playerSkills = _playerProfile get "skills";

        _playerSkills set ["driving", 1];

        private _vgmUID = format ["%1_%2", "player", _playerUID];
        [_vgmUID, _playerProfile] call vgm_s_fnc_db_save;
*/

params ["_key", "_id", "_data", "_fnc_handler"];

if !(_data isEqualType createHashMap) exitWith {
    ["ERROR", format ["VGM: Failure to save %1. Data is not a hashmap: %2", _id, _data]] call para_g_fnc_log;
};

private _fnc = format ["vgm_s_fnc_db_%1_set", missionNamespace getVariable "vgm_g_dbBackendType"];
[_key, _id, _fnc_handler] call (missionNamespace getVariable [_fnc, {format ["Invalid DB function: %1", _fnc]}]);

nil
