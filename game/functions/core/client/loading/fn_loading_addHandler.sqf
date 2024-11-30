/*
    File: fn_loading_addHandler.sqf
    Author: Savage Game Design
    Date: 2023-09-08
    Last Update: 2024-11-21
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        ["leveling", {
            !isNil {player getVariable "vgm_g_levelingData"}
        }] call vgm_c_fnc_loading_addHandler;
 */

params ["_name", "_fnc_handler"];

if (isNil "vgm_loading_handlers") then {
    vgm_loading_handlers = [];
};

vgm_loading_handlers pushBack createHashMapFromArray [
    ["name", _name],
    ["handler", _fnc_handler]
];
