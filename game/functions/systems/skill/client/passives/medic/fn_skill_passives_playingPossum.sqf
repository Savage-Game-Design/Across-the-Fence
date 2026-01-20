/*
    File: fn_skill_passives_playingPossum.sqf
    Author: Savage Game Design
    Date: 2026-01-11
    Last Update: 2026-01-20
    Public: No

    Description:
        Adds logic for Medic Playing Possum skill.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [true] call vgm_c_fnc_skill_passives_playingPossum
 */

params ["_known"];

if (!_known) exitWith {
    private _ehMission = player getVariable "vgm_c_skill_passives_playingPossumMissionEH";
    if (!isNil "_ehMission") then {
        [_ehMission] call para_g_fnc_event_unsubscribe;
    };

    private _ehActivate = player getVariable "vgm_c_skill_passives_playingPossumActivateEH";
    if (!isNil "_ehActivate") then {
        [_ehActivate] call para_g_fnc_event_unsubscribe;
    };

    player setVariable ["vgm_g_skill_canPlayPossum", false, true];
};

private _ehMission = ["vgm_mission_deploy_local", {
    player setVariable ["vgm_g_skill_canPlayPossum", true, true];
}] call para_g_fnc_event_subscribeGlobal;

player setVariable [ "vgm_c_skill_passives_playingPossumMissionEH", _ehMission];

private _ehActivate = ["vgm_skill_passives_playingPossum", {
    private _canActivate = player getVariable ["vgm_g_skill_canPlayPossum", false];
    if (!_canActivate) exitWith {};

    ["Medic/Playing possum skill activated"] call vgm_g_fnc_logInfo;
    hint localize "STR_VGM_SKILLS_SKILL_PLAYING_POSSUM_ACTIVATED";

    player call vgm_c_fnc_medical_fullHeal;
    player setVariable ["vgm_g_skill_canPlayPossum", false, true];

}] call para_g_fnc_event_subscribeServer;

player setVariable [ "vgm_c_skill_passives_playingPossumActivateEH", _ehActivate];
