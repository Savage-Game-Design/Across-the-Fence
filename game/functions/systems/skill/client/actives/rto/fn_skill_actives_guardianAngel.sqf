/*
    File: fn_skill_actives_guardianAngel.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Activates the "Guardian Angel" skill.
        Resets cooldowns on all other RTO active skills.

    Parameter(s):
        _activatingUnit - Unit activating skill [UNIT]
        _skill - Skill being activated [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_guardianAngel
 */

params ["_activatingUnit", "_skill"];

// Block if player is inside a radio jammer's radius
private _jamDist = call vgm_c_fnc_radioJamming_isPlayerJammed;
if (_jamDist >= 0) exitWith {
    hint format [localize "STR_VGM_RADIO_JAMMED", (round (_jamDist / 100)) * 100];
    playSoundUI ["3DEN_notificationWarning", 0.5];
};

["RTO/Guardian Angel skill activated"] call vgm_g_fnc_logInfo;

// Radio transmission raises alertness — PAVN intercepts comms
[group player getVariable "vgm_g_missionId"] remoteExecCall ["vgm_s_fnc_director_onRadioTransmission", 2];

private _thisSkillPath = _skill get "path";

{
    private _slotSkill = [_y] call vgm_c_fnc_skills_active_getSlotSkill;
    if (_slotSkill getOrDefault ["path", []] isNotEqualTo _thisSkillPath) then {
        // Only reset RTO tree skills
        private _path = _slotSkill getOrDefault ["path", []];
        if (count _path > 0 && {(_path select 0) == "rto"}) then {
            [_y] call vgm_c_fnc_skills_active_resetSlotCooldown;
        };
    };
} forEach vgm_c_skills_active_slots;

hint "CAS skill cooldowns reset.";
