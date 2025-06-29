/*
    File: fn_db_get.sqf
    Author: Savage Game Design
    Date: 2022-11-11
    Last Update: 2025-06-29
    Public: Yes

    Description:
        Returns the value of a database entry.

    Parameter(s):
        0: Key      - Type of entry IE: "player" or "vehicle" [STRING]
        1: ID       - ID of the entry IE: getPlayerUID [STRING]
        2: HANDLER  - Function that will handle the database entry [CODE]

    Returns:
        0: Value -  HASHMAP

    Example(s):
        ["leveling", getPlayerUID player, {}] call vgm_s_fnc_db_get;
*/

params ["_key", "_id", "_fnc_handler", "_arguments"];

private _fnc = format ["vgm_s_fnc_db_%1_get", missionNamespace getVariable "vgm_g_dbBackendType"];
[_key, _id, _fnc_handler, _arguments] call (missionNamespace getVariable [_fnc, {format ["Invalid DB function: %1", _fnc]}]);

nil
