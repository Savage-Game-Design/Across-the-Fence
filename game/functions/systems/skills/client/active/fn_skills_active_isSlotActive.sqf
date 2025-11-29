/*
    File: fn_skills_active_isSlotActive.sqf
    Author: veteran29
    Date: 2023-02-01
    Last Update: 2025-11-29
    Public: Yes

    Description:
        Check if given slot is already active

    Parameter(s):
        _slot - Slot [HASHMAP]

    Returns:
        Something [BOOL]

    Example(s):
        _slot call vgm_c_fnc_skills_active_isSlotActive
 */

params [
    ["_slot", createHashMap, ["", createHashMap]]
];

if (_slot isEqualType "") then {
    _slot = vgm_c_skills_active_slots getOrDefault [_slot, createHashMap];
};

time < (_slot getOrDefault ["activeUntil", 1e10]) // return
