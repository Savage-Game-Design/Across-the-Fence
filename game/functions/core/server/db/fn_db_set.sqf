/*
    File: fn_db_set.sqf
    Author: Cerebral
    Date: 2022-11-11
    Last Update: 2022-11-11
    Public: No

    Description:
        Creates or updates a database entry from a key.

    Parameter(s):
        0: Key  - Type of entry IE: "player" or "vehicle" [STRING]
        1: ID   - ID of the entry IE: getPlayerUID [STRING]
        2: Data - Data for the entry [HASHMAP]

    Returns: nothing

    Example:
        private _playerUID = getPlayerUID player;
        private _playerProfile = ["player", _playerUID] call vgm_fnc_db_get;
        private _playerSkills = _playerProfile get "skills";

        _playerSkills set ["driving", 1];

        ["player", _playerUID, _playerProfile] call vgm_s_fnc_db_set;
*/

params ["_key", "_id", "_data"];

if !(_data isEqualType createHashMap) exitWith {
	diag_log format ["VGM: Failure to save %1(%2). Data is not a hashmap: %2", _key, _id, _data];
};

if !(_data find "version") then {
	_data set ["version", getText(missionConfigFile >> "version")];
};

missionProfileNamespace setVariable [format ["vgm_%1_%2", _key, _id], _data];
