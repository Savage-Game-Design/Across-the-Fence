/*
    File: fn_skills_active_resetSlotCooldown.sqf
    Author: Savage Game Design
    Date: 2025-11-29
    Last Update: 2025-11-29
    Public: Yes

    Description:
        Resets the cooldown of the given slot

    Parameter(s):
        _slot - Slot [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [_slot] call vgm_c_fnc_skills_active_resetSlotCooldown;
        // or
        ["ability1"] call vgm_c_fnc_skills_active_resetSlotCooldown;
 */

params [
    ["_slot", createHashMap, ["", createHashMap]]
];

if (_slot isEqualType "") then {
    _slot = vgm_c_skills_active_slots getOrDefault [_slot, createHashMap];
};

_slot set ["cooldownUntil", 0];

