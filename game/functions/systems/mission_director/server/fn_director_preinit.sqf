#include "..\..\sites\sites.inc"
/*
    File: fn_director_preinit.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2025-01-05
    Public: No

    Description:
        Preinit for the mission director system

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_s_fnc_director_preinit;
 */

vgm_s_director_max_alertness = 100;
vgm_s_director_tracker_spawn_alertness_threshold = 3;
vgm_s_director_min_time_between_trackers_secs = 90;
vgm_s_director_max_time_between_trackers_secs = 600;
vgm_s_director_dynamic_max_groups = 8;
vgm_s_director_noiseEventAlertness = createHashMapFromArray [
    ["player_explosion", 2],
    ["player_flare", 5],
    // These are per reported event, not individual shot. Danger report clumps shots into short windows for each player.
    ["unsuppressedShots", 1.0],
    ["suppressedShots", 0.5]
];

vgm_s_director_defenseSquadSizes = createHashMapFromArray [
    [SITE_FOOTPRINT_SMALL, 3],
    [SITE_FOOTPRINT_MEDIUM, 6],
    [SITE_FOOTPRINT_LARGE, 9]
];

// TODO - Replace these with Mike Force's squad generator
vgm_s_director_patrol_classes = [
    'vn_o_men_nva_02',
    'vn_o_men_nva_04',
    'vn_o_men_nva_07',
    'vn_o_men_nva_05',
    'vn_o_men_nva_13',
    'vn_o_men_nva_45',
    'vn_o_men_nva_05',
    'vn_o_men_nva_06',
    'vn_o_men_nva_02',
    'vn_o_men_nva_04',
    'vn_o_men_nva_07',
    'vn_o_men_nva_05',
    'vn_o_men_nva_13',
    'vn_o_men_nva_45',
    'vn_o_men_nva_05',
    'vn_o_men_nva_06'
];

vgm_s_director_tracker_classes = [
    'vn_o_men_nva_02',
    'vn_o_men_nva_04',
    'vn_o_men_nva_07',
    'vn_o_men_nva_05',
    'vn_o_men_nva_13',
    'vn_o_men_nva_45',
    'vn_o_men_nva_05',
    'vn_o_men_nva_06',
    'vn_o_men_nva_02',
    'vn_o_men_nva_04',
    'vn_o_men_nva_07',
    'vn_o_men_nva_05',
    'vn_o_men_nva_13',
    'vn_o_men_nva_45',
    'vn_o_men_nva_05',
    'vn_o_men_nva_06'
];

vgm_s_director_defense_classes = [
    'vn_o_men_nva_02',
    'vn_o_men_nva_04',
    'vn_o_men_nva_07',
    'vn_o_men_nva_05',
    'vn_o_men_nva_13',
    'vn_o_men_nva_45',
    'vn_o_men_nva_05',
    'vn_o_men_nva_06',
    'vn_o_men_nva_02',
    'vn_o_men_nva_04',
    'vn_o_men_nva_07',
    'vn_o_men_nva_05',
    'vn_o_men_nva_13',
    'vn_o_men_nva_45',
    'vn_o_men_nva_05',
    'vn_o_men_nva_06'
];

vgm_s_director_attack_classes = [
    'vn_o_men_nva_11',
    'vn_o_men_nva_49',
    'vn_o_men_nva_11',
    'vn_o_men_nva_07',
    'vn_o_men_nva_49'
];

[
    "vgm_medical_unconscious",
    {
        (_this # 0) params ["_unit", "_state"];

        if (!_state) exitWith {};

        private _playerId = getPlayerID _unit;

        if !([getPlayerID _unit] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {};

        private _mission = [_playerId] call vgm_s_fnc_missions_getAssignedMission;

        if (isNil "_mission") exitWith {};

        private _playersOnMission = units _unit;
        private _alivePlayers = _playersOnMission select {alive _x && {lifeState _x != "INCAPACITATED"}};

        if (_alivePlayers isNotEqualTo []) exitWith {};

        [_mission get "public" get "id", "FAILURE"] call vgm_s_fnc_missions_endMission;
    }
] call para_g_fnc_event_subscribe;

["vgm_mission_attached", {
    (_this#0) params ["_playerId", "_missionId"];
    private _mission = [_missionId] call vgm_s_fnc_missions_getById;
    if (isNil "_mission" || {(_mission get "public" get "status") != "IN PROGRESS"}) exitWith {};
    getUserInfo _playerId params ["", "_machineId"];

    [] remoteExec ["vgm_c_fnc_director_startClientsideMonitoring", _machineId];

    ["vgm_mission_director_jipData", [_mission get "director" get "aiGroups"], _machineId] call para_g_fnc_event_triggerTargets;
}] call para_g_fnc_event_subscribeLocal;

// handle extraction
call {
    ["vgm_missions_gameplay_extractionStarted", {
        (_this#0) spawn {
            params ["_missionId", "_lzPos", "_helicopter"];

            private _mission = [_missionId] call vgm_s_fnc_missions_getById;
            private _playerGroup = _mission get "public" get "group";

            sleep 3;
            [
                _playerGroup,
                format ["vgm_extract_%1", _missionId],
                ["STR_VGM_MISSIONS_EXTRACTION_TASK_MAIN_DESCRIPTION", "STR_VGM_MISSIONS_EXTRACTION_TASK_MAIN_TITLE"],
                _lzPos,
                "ASSIGNED",
                -1,
                true,
                "heli"
            ] call BIS_fnc_taskCreate;

            waitUntil {_helicopter getVariable ["vgm_missions_extractionLanded", false]};

            [
                _playerGroup,
                [format ["vgm_extract_%1_board", _missionId], format ["vgm_extract_%1", _missionId]],
                ["", "STR_VGM_MISSIONS_EXTRACTION_TASK_BOARD_TITLE"],
                [_helicopter, true],
                "ASSIGNED",
                -1,
                true,
                "getin"
            ] call BIS_fnc_taskCreate;
        };
    }] call para_g_fnc_event_subscribeLocal;

    ["vgm_missions_gameplay_extractionLiftOff", {
        (_this#0) params ["_missionId", "_helicopter"];

        [format ["vgm_extract_%1_board", _missionId], "SUCCEEDED"] call BIS_fnc_taskSetState;
    }] call para_g_fnc_event_subscribeLocal;

    ["vgm_mission_ended", {
        (_this#0) params ["_missionId", "_helicopter"];

        [format ["vgm_extract_%1", _missionId], true, true] call BIS_fnc_deleteTask;
    }] call para_g_fnc_event_subscribeLocal;
};
