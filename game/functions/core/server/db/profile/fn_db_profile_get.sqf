/*
    File: fn_db_get.sqf
    Author: Cerebral
    Date: 2022-11-11
    Last Update: 2025-06-29
    Public: No

    Description:
        Returns the value of a database entry.

    Parameter(s):
        0: Key - Type of entry IE: "player" or "vehicle" [STRING]
        1: ID  - ID of the entry IE: getPlayerUID [STRING]

    Returns:
        Nothing

    Example(s):
        ["leveling", getPlayerUID player, {
            params ["_data", "_arguments"];
            diag_log format ["Leveling data for %1 is:", _arguments, _data];
        }, getPlayerUID player] call vgm_s_fnc_db_profile_get;
*/

params ["_key", "_id", "_fnc_handler", "_arguments"];

private _variable = format ["vgm_%1_%2", _key, _id];
private _data = profileNamespace getVariable [_variable, createHashMap];

[_data, _fnc_handler, _arguments] call {
    // disable local variable inheritance to make the behaviour more or less the same as event handler callbacks
    // this brings dev env closer to how actual backend behaves.
    privateAll;
    params ["_data","_fnc_handler", "_arguments"];
    [_data, _arguments] call _fnc_handler;
};

true
