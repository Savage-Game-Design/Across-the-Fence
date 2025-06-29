/*
    File: fn_db_profile_set.sqf
    Author: Savage Game Design
    Date: 2025-06-29
    Last Update: 2025-06-29
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_key", "_id", "_data", "_fnc_handler", "_arguments"];

private _variable = format ["vgm_%1_%2", _key, _id];
profileNamespace setVariable [_variable, _data];

[+_data, _fnc_handler, _arguments] call {
    // disable local variable inheritance to make the behaviour more or less the same as event handler callbacks
    // this brings dev env closer to how actual backend behaves.
    privateAll;
    params ["_data", "_fnc_handler", "_arguments"];
    [_data, _arguments] call _fnc_handler;
};

format ["VGM: Saved %1 with data: %2", _id, _data] call vgm_g_fnc_logInfo;

true
