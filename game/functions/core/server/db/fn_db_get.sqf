/*
    File: fn_db_get.sqf
    Author: Cerebral
    Date: 2022-11-11
    Last Update: 2025-08-29
    Public: Yes

    Description:
        Returns the value of a database entry.

    Parameter(s):
        0: Key - Type of entry IE: "player" or "vehicle" [STRING]
        1: ID  - ID of the entry IE: getPlayerUID [STRING]

    Returns:
        0: Value -  HASHMAP

    Example(s):
        ["player", getPlayerUID player] call vgm_s_fnc_db_get;
*/

params ["_key", "_id"];

private _variable = format ["vgm_%1_%2", _key, _id];
private _result = profileNamespace getVariable [_variable, createHashMap];

+_result
