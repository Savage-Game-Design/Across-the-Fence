/*
    File: fn_skills_active_isSlotted.sqf
    Author: Savage Game Design
    Date: 2023-05-07
    Last Update: 2023-05-07
    Public: Yes

    Description:
        Get slot the skill is equipped on.

    Parameter(s):
        _skill - Skill hashmap [HASHMAP]

    Returns:
        Slot name [STRING]

    Example(s):
        _skill call vgm_c_fnc_skills_active_getSlot
 */

params ["_skill"];

if (_skill isEqualTo createHashMap) exitWith {""};

{
    if (_skill isEqualTo (_y get "skill")) exitWith {_x};
    ""
} forEach vgm_c_skills_active_slots // return
