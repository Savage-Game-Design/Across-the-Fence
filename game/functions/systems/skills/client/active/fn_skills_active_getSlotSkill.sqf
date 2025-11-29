/*
    File: fn_skills_active_getSlotSkill.sqf
    Author: Savage Game Design
    Date: 2025-11-29
    Last Update: 2025-11-29
    Public: No

    Description:
        Gets the skill assigned to the slot

    Parameter(s):
        _slot - Slot or slot name [HASHMAP/STRING]

    Returns:
        Skill or empty hashmap [HASHMAP]

    Example(s):
        [_slot] call vgm_c_fnc_skills_active_getSlotSkill
        // or
        ["ability1"] call vgm_c_fnc_skills_active_getSlotSkill
 */

params [
    ["_slot", createHashMap, ["", createHashMap]]
];

if (_slot isEqualType "") then {
    _slot = vgm_c_skills_active_slots getOrDefault [_slot, createHashMap];
};

_slot getOrDefault ["skill", createHashMap]
