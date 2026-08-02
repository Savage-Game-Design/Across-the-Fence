/*
    File: fn_skill_actives_sitrep.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Activates the "Sitrep" skill.
        Requests alertness and enemy intel from the server, then displays it.

    Parameter(s):
        _activatingUnit - Unit activating skill [UNIT]
        _skill - Skill being activated [HASHMAP]

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skill_actives_sitrep
 */

params ["_activatingUnit", "_skill"];

// Block if player is inside a radio jammer's radius
private _jamDist = call vgm_c_fnc_radioJamming_isPlayerJammed;
if (_jamDist >= 0) exitWith {
    hint format [localize "STR_VGM_RADIO_JAMMED", (round (_jamDist / 100)) * 100];
    playSoundUI ["3DEN_notificationWarning", 0.5];
};

["RTO/Sitrep skill activated"] call vgm_g_fnc_logInfo;

// Radio transmission raises alertness — PAVN intercepts comms
[group player getVariable "vgm_g_missionId"] remoteExecCall ["vgm_s_fnc_director_onRadioTransmission", 2];

// Request intel from server — server will call back with the response
[player, group player getVariable "vgm_g_missionId"] remoteExecCall ["vgm_s_fnc_skill_actives_sitrep_server", 2];
