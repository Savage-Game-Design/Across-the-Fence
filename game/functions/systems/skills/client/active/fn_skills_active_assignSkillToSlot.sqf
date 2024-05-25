/*
    File: fn_skills_active_assignSkillToSlot.sqf
    Author: veteran29
    Date: 2023-02-01
    Last Update: 2023-06-02
    Public: Yes

    Description:
        Assigns skill into slot.

    Parameter(s):
        _slot - Name of the slot to assign the skill to [STRING]
        _skill - Skill to assign, pass nil to clear [HASHMAP]

    Returns:
        Skill was assigned into slot [BOOL]

    Example(s):
        [_slot, _skill] call vgm_c_fnc_skills_active_assignSkillToSlot
 */

params [
    ["_slot", "", [""]],
    ["_skill", createHashMap, [createHashMap]]
];

if (_slot == "ultimate" && {!(_skill get "isUltimate")}) exitWith {
    (format ["Unable to put primary skill %1 into ultimate slot", _skill get "path"]) call vgm_g_fnc_logWarning;
    false
};

if (_slot != "ultimate" && {_skill get "isUltimate"}) exitWith {
    (format ["Unable to put ultimate skill %1 into primary slot %2", _skill get "path", _slot]) call vgm_g_fnc_logWarning;
    false
};

if (_skill isNotEqualTo createHashMap && {values vgm_c_skills_active_slots findIf {_x get "skill" isEqualTo _skill} != -1}) exitWith {
    (format ["Skill already slotted %1", _skill get "path"]) call vgm_g_fnc_logWarning;
    false
};

private _assigned = vgm_c_skills_active_slots getOrDefault [_slot, createHashMap] set ["skill", _skill];

if (_assigned) then {
    ["vgm_skills_active_slotted", [_slot, _skill]] call para_g_fnc_event_triggerLocal;
};

_assigned // return
