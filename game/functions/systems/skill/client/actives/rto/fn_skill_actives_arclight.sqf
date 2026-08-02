/*
    File: fn_skill_actives_arclight.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Activates the "Arclight" skill.
        Opens a 60s window where the Arclight B-52 strike appears on the radio.

    Parameter(s):
        _activatingUnit - Unit activating skill [UNIT]
        _skill - Skill being activated [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_arclight
 */

params ["_activatingUnit", "_skill"];

// Block if player is inside a radio jammer's radius
private _jamDist = call vgm_c_fnc_radioJamming_isPlayerJammed;
if (_jamDist >= 0) exitWith {
    hint format [localize "STR_VGM_RADIO_JAMMED", (round (_jamDist / 100)) * 100];
    playSoundUI ["3DEN_notificationWarning", 0.5];
};

["RTO/Arclight skill activated"] call vgm_g_fnc_logInfo;

// Radio transmission raises alertness — PAVN intercepts comms
[group player getVariable "vgm_g_missionId"] remoteExecCall ["vgm_s_fnc_director_onRadioTransmission", 2];

player setVariable ["vgm_c_skill_arclight_active", true, true];

hint "Arclight B-52 strike available on the radio (60s).";

["skill_arclight", {
    ["RTO/Arclight skill window expired"] call vgm_g_fnc_logInfo;
    player setVariable ["vgm_c_skill_arclight_active", false, true];
}, 60, "seconds"] call BIS_fnc_runLater;
