/*
    File: fn_db_save_type.sqf
    Author: Cerebral
    Date: 2022-11-11
    Last Update: 2022-11-11
    Public: No

    Description:
        Saves data to database with a type.

    Parameter(s):
        0: Key  - Type of entry IE: "player" or "vehicle" [STRING]
        1: ID   - ID of the entry IE: getPlayerUID [STRING]
        2: Data - Data for the entry [HASHMAP]

    Returns:
        Nothing

    Example(s):
        private _playerUID = getPlayerUID player;
        private _playerProfile = ["player", _playerUID] call vgm_fnc_db_get;
        private _playerSkills = _playerProfile get "skills";

        _playerSkills set ["driving", 1];

        ["player", _playerUID, _playerProfile] call vgm_s_fnc_db_save_type;
*/

params ["_key", "_id", "_data"];

if !(_data isEqualType createHashMap) exitWith {
    ["ERROR", format ["VGM: Failure to save %1. Data is not a hashmap: %2", _id, _data]] call para_g_fnc_log;
};

// don't overwrite existing key
private _vgmID = format ["vgm_%1_%2", _key, _id];
// set key and id only if not present in data already
_data set ["key", _key, true];
_data set ["id", _vgmID, true];

_data set ["version", getText(missionConfigFile >> "version")];

private _formattedID = format ["%1_%2", _key, _id];
[_formattedID, _data] call vgm_s_fnc_db_save;
