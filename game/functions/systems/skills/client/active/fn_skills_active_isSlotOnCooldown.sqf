/*
    File: fn_skills_active_isSlotOnCooldown.sqf
    Author: veteran29
    Date: 2023-02-01
    Last Update: 2023-02-01
    Public: Yes

    Description:
        Check if given slot is on cooldown.

    Parameter(s):
        _slot - Slot [HASHMAP]

    Returns:
        Something [BOOL]

    Example(s):
        _slot call vgm_c_fnc_skills_active_isSlotOnCooldown
 */

params [
    ["_slot", createHashMap, ["", createHashMap]]
];

if (_slot isEqualType "") then {
    _slot = vgm_c_skills_active_slots getOrDefault [_slot, createHashMap];
};

time < (_slot getOrDefault ["cooldown", 1e10]) // return
