/*
    File: fn_db_get.sqf
    Author: Cerebral
    Date: 2022-11-11
    Last Update: 2022-11-11
    Public: No

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
private _value = missionProfileNamespace getVariable [_variable, []];

// ensure variable is an array or hashmap

private _result = [];
switch (typeName _value) do {
    case "ARRAY": {
        _result = createHashMapFromArray _value;
    };
    case "HASHMAP": {
        _result = _value;
    };
    default
    {
        ["ERROR", format ["VGM: Failure to gather data. ID probably overlaps with something that isn't an array or hashmap.", _id, _data]] call para_g_fnc_log;
    };
};

_result
