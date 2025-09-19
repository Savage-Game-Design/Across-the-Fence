#include "..\..\sites\sites.inc"
/*
    File: fn_director_preinit.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2025-09-19
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
vgm_s_director_alertness_period_secs = 5;
vgm_s_director_tracker_spawn_alertness_threshold = 6;
vgm_s_director_min_time_between_trackers_secs = 90;
vgm_s_director_max_time_between_trackers_secs = 600;
vgm_s_director_dynamic_max_groups = 8;
// Every alertness period will add a fixed amount of alertness based on the most significant event to happen.
vgm_s_director_noiseEventAlertness = createHashMapFromArray [
    ["player_explosion", [0, 3]],
    ["player_flare", 5],
    ["unsuppressedShots", 1.5],
    ["suppressedShots", 0.75]
];

vgm_s_director_defenseSquadSizeRanges = createHashMapFromArray [
    //[Site size, [ Min, Max ]]
    [SITE_FOOTPRINT_SMALL, [2, 4]],
    [SITE_FOOTPRINT_MEDIUM, [3, 6]],
    [SITE_FOOTPRINT_LARGE, [5, 10]]
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
    'vn_o_men_nva_49',
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

        private _playerId = getPlayerID _unit;
        private _logPrefix = format ["Director: Player %1 (ID: %2) unconscious", name _unit, _playerId];

        if (!_state) exitWith {};

        if !([getPlayerID _unit] call para_s_fnc_remoteExec_validateDirectPlayIdIsRemoteExecOwner) exitWith {
            [format ["%1 - Failed remoteExecOwner check", _logPrefix]] call vgm_g_fnc_logWarning;
        };

        private _mission = [_playerId] call vgm_s_fnc_missions_getAssignedMission;

        if (isNil "_mission") exitWith {
            [format ["%1 - Not on a mission", _logPrefix]] call vgm_g_fnc_logDebug;
        };

        private _missionId = _mission get "public" get "id";
        _logPrefix = format ["%1 (Mission: %2)", _logPrefix, _missionId];
        private _playersOnMission = units _unit;
        private _alivePlayers = _playersOnMission select {alive _x && {!(_x call vgm_g_fnc_medical_isUnconscious)}};
        private _playersAbleToRespawn = (_playersOnMission - _alivePlayers) select { [_x] call vgm_g_fnc_respawn_remainingRespawns > 0 };

        if (_alivePlayers isNotEqualTo [] || _playersAbleToRespawn isNotEqualTo []) exitWith {
            [format [
                "%1 - Mission continues - %2 out of %3 players are alive, %4 out of %3 can respawn",
                _logPrefix, count _alivePlayers, count _playersOnMission, count _playersAbleToRespawn
            ]] call vgm_g_fnc_logDebug;
        };

        [format ["%1 - No players alive, ending mission", _logPrefix]] call vgm_g_fnc_logDebug;

        [_missionId, "FAILURE"] call vgm_s_fnc_missions_endMission;
    }
] call para_g_fnc_event_subscribe;

["vgm_mission_attached", {
    (_this#0) params ["_playerId", "_missionId"];
    private _mission = [_missionId] call vgm_s_fnc_missions_getById;
    if (isNil "_mission" || {(_mission get "public" get "status") != "IN PROGRESS"}) exitWith {};
    getUserInfo _playerId params ["", "_machineId"];

    [] remoteExec ["vgm_c_fnc_director_startClientsideMonitoring", _machineId];

    ["vgm_mission_director_jipData", [values (_mission get "director" get "virtualSquadGroups")], _machineId] call para_g_fnc_event_triggerTargets;
}] call para_g_fnc_event_subscribeLocal;

["vgm_virtsquad_created", {
    (_this # 0) params ["_squad"];

    private _missionId = _squad get "missionId";
    private _director = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;
    if (isNil "_director") exitWith {};
    _director get "virtualSquads" set [_squad get "id", _squad];

}] call para_g_fnc_event_subscribeLocal;

["vgm_virtsquad_deleted", {
    (_this # 0) params ["_squad"];

    private _missionId = _squad get "missionId";
    private _director = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;
    if (isNil "_director") exitWith {};
    _director get "virtualSquads" deleteAt (_squad get "id");

}] call para_g_fnc_event_subscribeLocal;

["vgm_virtsquad_spawned", {
    (_this # 0) params ["_squad"];

    private _missionId = _squad get "missionId";
    private _mission = [_missionId] call vgm_s_fnc_missions_getById;
    if (isNil "_mission") exitWith {};
    private _director = _mission get "director";
    private _group = _squad get "group";
    _director get "virtualSquadGroups" set [_squad get "id", _group];

    ["vgm_mission_director_groupsSpawned", [[_group]], values (_mission get "machineIds")] call para_g_fnc_event_triggerTargets;

}] call para_g_fnc_event_subscribeLocal;

["vgm_virtsquad_despawned", {
    (_this # 0) params ["_squad"];

    private _missionId = _squad get "missionId";
    private _director = [_missionId] call vgm_s_fnc_director_getDirectorForMissionId;
    if (isNil "_director") exitWith {};
    _director get "virtualSquadGroups" deleteAt (_squad get "id");

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

[] call vgm_s_fnc_director_preinitEngagements;
